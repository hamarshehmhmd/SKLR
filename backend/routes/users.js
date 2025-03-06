const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

// GET: /api/users, fetch ALL users
router.get("", async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('users')
            .select('*')

        res.status(200).json({ users: data });

        if (error) {
            throw error;
        }
    } catch (err) {
        console.error('Error fetching users: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// GET: /api/users/username/{username}
router.get("/username/:username", async (req, res) => {
    const username = req.params.username;
    try {
        const { data, error } = await supabase
            .from('users')
            .select('*')
            .eq('username', username);

        if (error) {
            throw error;
        }

        if (data.length > 0) {
            return res.status(200).json({ exists: true });
        }

        res.status(200).json({ exists: false });
    } catch (err) {
        console.error('Error fetching users: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// GET: /api/users/email/{email}
router.get("/email/:email", async (req, res) => {
    const email = req.params.email;
    try {
        const { data, error } = await supabase
            .from('users')
            .select('*')
            .eq('email', email);

        if (error) {
            throw error;
        }

        if (data.length > 0) {
            return res.status(200).json({ exists: true });
        }

        res.status(200).json({ exists: false });
    } catch (err) {
        console.error('Error fetching users: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// GET: /api/users/{user_id}, fetch specific user with user_id
router.get("/:user_id", async (req, res) => {
    const user_id = req.params.user_id;
    try {
        const { data, error } = await supabase
            .from('users')
            .select('username, email, phone_number, bio, credits, moderator')
            .eq('id', user_id)
            .single();

        res.status(200).json({ user: data });

        if (error) {
            throw error;
        }
    } catch (err) {
        console.error('Error fetching user: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// PATCH: /api/users/{user_id}, update user by user_id
router.patch("/:user_id", async (req, res) => {
    const user_id = req.params.user_id;
    const { username, email, password, phone_number, bio } = req.body;

    // check for empty or invalid request body
    if (!email && !password && !phone_number && !bio) {
        return res.status(400).json({ error: 'At least one field required' });
    }

    try {
        const updates = {};

        if (username) {
            updates.username = username;
        }

        if (email) {
            updates.email = email;
        }

        if (password) {
            const hashedPassword = await hash(password);
            updates.password = hashedPassword;
        }

        if (phone_number) {
            updates.phone_number = phone_number;
        }

        if (bio) {
            updates.bio = bio;
        }

        const { data, error } = await supabase
            .from('users')
            .update(updates)
            .eq('id', user_id)
            .single()
            .select()

        if (error) {
            console.error(error);
            return res.status(500).json({ error: 'Error updating user' });
        }

        return res.status(200).json({ message: 'Successfully updated user', user: data });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

// POST: /api/users/{user_id}/award, award user w. 1 credit upon verification of phone number
router.post('/:user_id/award', async (req, res) => {
    const user_id = req.params.user_id;

    try {
        // check if user has already been awarded (phone_number != null)
        const { checkData, checkError } = await supabase
            .from('users')
            .select('phone_number')
            .eq('id', user_id)
            .single();

        if (checkError) {
            console.error(error);
            return res.status(500).json({ error: 'Error reading values from user' });
        }
        
        if (checkData && checkData['phone_number']) {
            return res.status(400).json({ error: 'User has already verified a phone number' });
        }

        const { data, error } = await supabase
            .rpc('increment-credits', { user_id: user_id });

        if (error) {
            console.error(error);
            return res.status(500).json({ error: 'Error updating user' });
        }

        return res.status(200).json({ message: 'Successfully updated user' });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

// DELETE: /api/users/{user_id}, delete user by user_id
router.delete('/:user_id', async (req, res) => {
    const user_id = req.params.user_id;

    try {
        const { data, error } = await supabase
            .from('users')
            .delete()
            .eq('id', user_id)
            .single()
            .select();

        if (error) {
            console.error(error);
            return res.status(404).json({ error: 'User not found or could not be deleted' });
        }

        return res.status(200).json({ message: 'User deleted successfully', user: data });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
