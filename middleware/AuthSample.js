export const verifyUser = (req, res, next) => {
    if (!req.session.userId) {
        return res.status(401).json({ msg: "Unauthorized" });
    }
    req.userId = req.session.userId; // Menambahkan userId ke request
    next();
};
