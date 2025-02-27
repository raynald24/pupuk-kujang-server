import Users from "../models/UserModel.js"
import argon2 from "argon2";


export const getUsers = async(req, res) => {
    try {
        const response = await Users.findAll({
            attributes:['uuid', 'name', 'email','role']
        });
        res.status(200).json(response);
    } catch (error) {
        res.status(500).json({msg: error.message});
    }
}
export const getUserById = async(req, res) => {
    try {
        const response = await Users.findOne({
            attributes:['uuid', 'name', 'email','role'],
            where: {
                uuid:req.params.id
            }
        });
        res.status(200).json(response);
    } catch (error) {
        res.status(500).json({msg: error.message});
    }
    
}
export const createUser = async(req, res) => {
    const { name, email, password, confPassword, role } = req.body;
    console.log("Data received:", req.body);
    if(password !== confPassword) return res.status(400).json({msg : "Password and Confirm password not matching"});
    const hashPassword = await argon2.hash(password);
    try {
        await Users.create({
            name: name,
            email: email,
            password: hashPassword,
            role: role
        });
        res.status(201).json({msg: "register berhasil"});
    } catch (error) {
        
        res.status(400).json({msg: error.message});
    }
}

export const updateUser = async (req, res) => {
    // Mencari user berdasarkan UUID
    const user = await Users.findOne({
        where: {
            uuid: req.params.id // ID dari params
        }
    });

    if (!user) return res.status(404).json({ msg: "User not found" });

    const { name, email, password, confPassword, role } = req.body;

    let hashPassword = user.password; 
    if (password && password !== '') {
        if (password !== confPassword) return res.status(400).json({ msg: "Password and confirm password do not match" });
        hashPassword = await argon2.hash(password); 
    }
    try {
        // Mengupdate data user
        await Users.update({
            name: name,
            email: email,
            password: hashPassword,
            role: role
        }, {
            where: { id: user.id }
        });

        res.status(200).json({ msg: "User updated successfully" });

    } catch (error) {
        console.error(error);
        res.status(400).json({ msg: error.message });
    }
};

export const deleteUser = async (req, res) => {
    const user = await Users.findOne({
        where: {
            uuid:req.params.id
        }
    });
    if(!user) return res.status(404).json({msg: " user not found"});
    try {
        await Users.destroy({
            where: {
                id: user.id
            }
        });
        res.status(200).json({msg: "delete user berhasil"});
    } catch (error) {
        
        res.status(400).json({msg: error.message});
    }
}
