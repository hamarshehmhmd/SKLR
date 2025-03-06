const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();
const { hash, check } = require("../helpers/password");

// POST: /api/register, create new user
router.post('/register', async (req, res) => {
    const { username, email, password } = req.body;

    // validation
    if (!username || !email || !password) {
        return res.status(400).json({ error: 'Username, Email, and Password are required' });
    }

    try {
        // query database for already existing user
        const { data: exists, error: existsError } = await supabase
            .from('users')
            .select('*')
            .eq('email', email)
            .single();

        // user with provided credentials already exists
        if (exists) {
            return res.status(409).json({ error: 'User already exists' });
        }

        // supabase throws error (which includes no rows found, which is fine)
        if (existsError && existsError.code === 'PGRST116') {
            console.log("No user with email provided, proceed to creation");
        }

        const hashedPassword = await hash(password);

        const { data, error } = await supabase
            .from('users')
            .insert([
                {
                    username: username,
                    email: email,
                    password: hashedPassword,
                }
            ])
            .select('id')
            .single();

        if (error) {
            throw error;
        }
        
        res.status(201).json({ message: 'User created successfully', user: data });
    } catch (err) {
        console.error('Error creating user: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// POST: /api/login, login user
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    // validation
    if (!email || !password) {
        return res.status(400).json({ error: 'Email and Password are required' });
    }

    try {
        const hashedPassword = await hash(password);

        // look for user with provided email
        const { data: user, error } = await supabase
            .from('users')
            .select('*')
            .eq('email', email)
            .single();

        if (error || !user) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        // match password provided to users hashed password
        const passwordMatch = await check(password, user.password);

        if (!passwordMatch) {
            return res.status(401).json({ error: 'Invalid email or password '});
        }

        // pass along user_id for storage in sharedPreferences
        return res.status(200).json({ user_id: user.id });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
