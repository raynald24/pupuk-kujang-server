import AnalysisResult from "../models/AnalysisResult.js";
import ParameterInput from "../models/ParameterInput.js";  // Mengimpor model ParameterInput untuk mengambil data parameter
import Sample from "../models/SampleModel.js";  // Mengimpor model Sample untuk mengakses data sampel

// Create Analysis Result
export const createAnalysisResult = async (req, res) => {
  const { sampleId, parameterId, hasilPerhitungan, tanggalAnalisa, analisaNumber, publishAnalisa } = req.body;

  try {
    // Cek apakah Sample dan Parameter yang dipilih ada
    const sample = await Sample.findByPk(sampleId);
    if (!sample) return res.status(404).json({ msg: "Sample not found" });

    const parameter = await ParameterInput.findOne({ where: { sampleId, parameterId } });
    if (!parameter) return res.status(404).json({ msg: "Parameter not found" });

    // Simpan hasil analisa
    const newAnalysisResult = await AnalysisResult.create({
      sampleId,
      parameterId,
      hasilPerhitungan,
      tanggalAnalisa,
      analisaNumber,
      publishAnalisa
    });

    res.status(201).json({ msg: "Analysis result created successfully", newAnalysisResult });
  } catch (error) {
    console.error("Error creating analysis result:", error);
    res.status(500).json({ msg: error.message });
  }
};

// Get Analysis Results by SampleId
export const getAnalysisResultsBySampleId = async (req, res) => {
  const { sampleId } = req.params;
  
  try {
    const results = await AnalysisResult.findAll({
      where: { sampleId },
      include: [
        { model: Sample, attributes: ['nomorPO', 'namaUnitPemohon'] },  // Menampilkan data terkait sampel
        { model: ParameterInput, attributes: ['v1', 'v2', 'v3', 'hasil'] }  // Menampilkan input parameter dan hasilnya
      ]
    });

    if (results.length === 0) return res.status(404).json({ msg: "No analysis results found for this sample" });

    res.status(200).json(results);
  } catch (error) {
    console.error("Error fetching analysis results:", error);
    res.status(500).json({ msg: error.message });
  }
};
