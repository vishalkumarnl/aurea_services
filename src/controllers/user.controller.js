export const getProfile = (req, res) => {
  const user = req.user;
  res.status(200).json({
   user: { name: user.name,
    email: user.email,
    gender: user.gender,
    mobile: user.mobile,}
  });
};
