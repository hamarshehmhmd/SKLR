const bcrypt = require("bcrypt");

const SALT_ROUNDS = 10;

// hash password w. 10 rounds of salt
const hash = async (plain) => {
    try {
        const salt = await bcrypt.genSalt(SALT_ROUNDS);
        const hashedPassword = await bcrypt.hash(plain, salt);
        return hashedPassword;
    } catch (err) {
        console.error('Error hashing password: ', err.message);
        throw err;
    }
};

// compare plaintext password w. hashed password
const check = async (plain, hashed) => {
    try {
        return await bcrypt.compare(plain, hashed);
    } catch (err) {
        console.error('Error comparing passwords: ', err.message);
        throw err;
    }
};

module.exports = {
    hash,
    check,
};
