import Users from "../models/UserModel.js"
import argon2 from "argon2";

export const Login = async (req,res) => {
    const user = await Users.findOne({
        where: {
            email: req.body.email
        }
    });
    if(!user) return res.status(404).json({msg: " user not found"});
    const match = await argon2.verify(user.password, req.body.password)
    if(!match) return res.status(400).json({msg : "wrong password"});
    req.session.userId =user.uuid;
    const uuid = user.uuid;
    const name = user.name;
    const email = user.email;
    const role = user.role
    res.status(200).json({uuid,name,email,role});
}


//function untuk front-end get user login
export const Me = async (req,res) => {
    if(!req.session.userId){
        return res.status(401).json({msg:" Mohon login ke akun anda"});
    }
    const user = await Users.findOne({
        attributes: ['uuid','name','email','role'],
        where: {
            uuid: req.session.userId
        }
    });
    if(!user) return res.status(404).json({msg: " user not found"});
    res.status(200).json(user);
}

export const Logout = async (req,res) => {
    req.session.destroy((err)=>{
        if(err) return res.status(400).json({msg: "Tidal dapat logout"})
            res.clearCookie('connect.sid');
        res.status(200).json({msg:"Anda telah Logout"})
    })
}