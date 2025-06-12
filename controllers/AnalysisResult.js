import AnalysisResult from '../models/AnalysisResult.js';
import ParameterInput from '../models/ParameterInput.js';
import Sample from '../models/SampleModel.js';
import Parameter from '../models/parameters.js';
import namaBahan from '../models/namaBahan.js';

const getParameters = async (req, res) => {
  try {
    const parameters = await Parameter.findAll({
      where: { namaBahanId: req.params.namaBahanId },
      include: [{ model: namaBahan }],
    });

    if (!parameters.length) {
      return res.status(404).json({ message: 'No parameters found for this material' });
    }

    const formattedMaterials = {
      materials: [
        {
          name: parameters[0]?.namaBahan?.namaBahan || 'Unknown Material',
          parameters: parameters.map(param => ({
            name: param.name,
            type: param.type,
            formula: param.formula,
            inputs: param.inputs ? (typeof param.inputs === 'string' ? JSON.parse(param.inputs) : param.inputs) : [],
          })),
        },
      ],
    };
    res.status(200).json(formattedMaterials);
  } catch (err) {
    console.error('Error fetching parameters:', err.message);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const saveAnalysis = async (req, res) => {
  const { sample_id, analysis_number, analysis_date, publish_analisa, parameters } = req.body;

  const payloadSize = Buffer.byteLength(JSON.stringify(req.body), 'utf8');
  console.log(`Payload size: ${payloadSize / 1024} KB`);
  console.log(`Received payload:`, JSON.stringify(req.body, null, 2));

  try {
    if (!sample_id || !analysis_number || !analysis_date || !publish_analisa || !parameters) {
      return res.status(400).json({
        message: 'Missing required fields',
        missing: {
          sample_id: !sample_id,
          analysis_number: !analysis_number,
          analysis_date: !analysis_date,
          publish_analisa: !publish_analisa,
          parameters: !parameters,
        },
      });
    }

    const sample = await Sample.findOne({ where: { uuid: sample_id } });
    if (!sample) {
      return res.status(404).json({ message: 'Sample not found' });
    }

    // Pastikan semua entri AnalysisResult menggunakan publish_analisa yang sama
    for (const param of parameters) {
      if (!param.inputs || typeof param.inputs !== 'object' || Object.keys(param.inputs).length === 0) {
        console.log(`Skipping parameter ${param.name}: invalid or empty inputs`);
        continue;
      }

      const parameter = await Parameter.findOne({ where: { name: param.name } });
      if (!parameter) {
        console.log(`Parameter ${param.name} not found`);
        continue;
      }

      let resultValue;
      console.log(`Received param.result: ${param.result}, param.inputs=${JSON.stringify(param.inputs)}`);
      if (param.result != null && param.result !== '' && param.result !== 'NaN' && !Number.isNaN(param.result)) {
        resultValue = String(param.result);
      } else if (parameter.type === 'enum' || parameter.type === 'manual') {
        const inputValue = Object.values(param.inputs)[0];
        resultValue = inputValue != null && inputValue !== '' ? String(inputValue) : null;
      } else {
        resultValue = null;
      }

      console.log(
        `Saving parameter ${param.name}: inputs=${JSON.stringify(param.inputs)}, resultValue=${resultValue}, publish_analisa=${publish_analisa}`,
      );

      let analysis = await AnalysisResult.findOne({
        where: { sampleId: sample.id, parameterId: parameter.id },
      });
      if (analysis) {
        await analysis.update({
          analisaNumber: analysis_number,
          tanggalAnalisa: analysis_date,
          publishAnalisa: publish_analisa, // Gunakan nilai dari payload tanpa fallback
          hasilPerhitungan: resultValue,
        });
        console.log(`Updated AnalysisResult for ${param.name}: publishAnalisa=${publish_analisa}`);
      } else {
        analysis = await AnalysisResult.create({
          sampleId: sample.id,
          parameterId: parameter.id,
          analisaNumber: analysis_number,
          tanggalAnalisa: analysis_date,
          publishAnalisa: publish_analisa, // Gunakan nilai dari payload tanpa fallback
          hasilPerhitungan: resultValue,
        });
        console.log(`Created AnalysisResult for ${param.name}: publishAnalisa=${publish_analisa}`);
      }

      await ParameterInput.destroy({
        where: { analysisId: analysis.id, parameterId: parameter.id },
      });

      await ParameterInput.create({
        analysisId: analysis.id,
        parameterId: parameter.id,
        inputs: JSON.stringify(param.inputs),
      });
    }

    res.status(201).json({ message: 'Analysis saved successfully' });
  } catch (err) {
    console.error('Error saving analysis:', err.message, err.stack);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

const getAnalysisBySample = async (req, res) => {
  try {
    const sample = await Sample.findOne({ where: { uuid: req.params.sampleId } });
    if (!sample) {
      return res.status(404).json({ message: 'Sample not found' });
    }

    // Ambil entri terbaru untuk setiap parameterId, hindari duplikasi
    const analyses = await AnalysisResult.findAll({
      where: { sampleId: sample.id },
      include: [
        { model: ParameterInput, as: 'ParameterInputs' },
        { model: Parameter, as: 'Parameter' },
      ],
      order: [['createdAt', 'DESC']], // Urutkan berdasarkan tanggal pembuatan terbaru
    });

    if (!analyses.length) {
      return res.status(200).json({ message: 'No analysis found for this sample', parameters: [] });
    }

    // Filter untuk menghindari duplikasi berdasarkan parameterId
    const uniqueAnalyses = [];
    const seenParameterIds = new Set();
    for (const analysis of analyses) {
      if (!seenParameterIds.has(analysis.parameterId)) {
        seenParameterIds.add(analysis.parameterId);
        uniqueAnalyses.push(analysis);
      }
    }

    console.log(`Fetched analyses for sample ${req.params.sampleId}:`, JSON.stringify(uniqueAnalyses, null, 2));

    const response = {
      sample_id: req.params.sampleId,
      analysis_number: uniqueAnalyses[0].analisaNumber,
      analysis_date: uniqueAnalyses[0].tanggalAnalisa,
      publish_analisa: uniqueAnalyses[0].publishAnalisa, // Ambil dari entri terbaru
      parameters: uniqueAnalyses.map(analysis => ({
        name: analysis.Parameter?.name || 'Unknown',
        inputs: analysis.ParameterInputs[0]?.inputs ? JSON.parse(analysis.ParameterInputs[0].inputs) : {},
        result: analysis.hasilPerhitungan,
      })),
    };

    res.status(200).json(response);
  } catch (err) {
    console.error('Error fetching analysis:', err.message);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

export { getParameters, saveAnalysis, getAnalysisBySample };