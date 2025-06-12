import ParameterInput from "../models/ParameterInput.js";
import Sample from "../models/SampleModel.js";
import Parameter from "../models/parameters.js";

// Create Parameter Input
export const createParameterInput = async (req, res) => {
  const { sampleId, parameterId, v1, v2, v3, faktorPengenceran, bobotKosong, bobotSampel, bobotSetelahPemanasan } = req.body;

  try {
    // Cek apakah Sample dan Parameter yang dipilih ada
    const sample = await Sample.findByPk(sampleId);
    if (!sample) return res.status(404).json({ msg: "Sample not found" });

    const parameter = await Parameter.findByPk(parameterId);
    if (!parameter) return res.status(404).json({ msg: "Parameter not found" });

    // Simpan data input parameter
    const newParameterInput = await ParameterInput.create({
      sampleId,
      parameterId,
      v1,
      v2,
      v3,
      faktorPengenceran,
      bobotKosong,
      bobotSampel,
      bobotSetelahPemanasan
    });

    res.status(201).json({ msg: "Parameter input created successfully", newParameterInput });
  } catch (error) {
    console.error("Error creating parameter input:", error);
    res.status(500).json({ msg: error.message });
  }
};

// Get Parameter Input by SampleId
export const getParameterInputBySampleId = async (req, res) => {
  const { sampleId } = req.params;

  try {
    const parameterInputs = await ParameterInput.findAll({
      where: { sampleId },
      include: [
        { model: Sample, attributes: ['nomorPO'] },
        { model: Parameter, attributes: ['namaParameter'] }
      ]
    });

    if (parameterInputs.length === 0) return res.status(404).json({ msg: "No parameter inputs found for this sample" });

    res.status(200).json(parameterInputs);
  } catch (error) {
    console.error("Error fetching parameter inputs:", error);
    res.status(500).json({ msg: error.message });
  }
};
