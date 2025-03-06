const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

// POST: /api/sessions, create a session
router.post('', async (req, res) => {
    const { requester_id, provider_id, skill_id } = req.body;

    // validation
    if (!requester_id || !provider_id || !skill_id) {
        return res.status(400).json({ error: 'Requester_id, Provider_id, Skill_id are required' });
    }

    try {
        const { data, error } = await supabase
            .from('sessions')
            .insert([
                {
                    requester_id: requester_id,
                    provider_id: provider_id,
                    skill_id: skill_id,
                }
            ])
            .select()
            .single();
        
        if (error) {
            throw error;
        }

        res.status(201).json({data});
    } catch (err) {
        console.error('Error creating session: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// GET: /api/sessions/{session_id}, get specific session
router.get('/:session_id', async (req, res) => {
    const session_id = req.params.session_id;

    try {
        const { data, error } = await supabase
            .from('sessions')
            .select('*')
            .eq('id', session_id)
            .single()

        if (error) {
            throw error;
        }

        res.status(200).json(data);

    } catch (err) {
        console.error('Error getting session ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// PATCH: /api/sessions/{session_id}, update session by session_id
router.patch('/:session_id', async (req, res) => {
    const session_id = req.params.session_id;
    const { status } = req.body;

    // check for empty or invalid request body
    if (!status) {
        return res.status(400).json({ error: 'At least one field required' });
    }

    try {
        const updates = {};

        if (status) {
            updates.status = status;
        }

        const { data, error } = await supabase
            .from('sessions')
            .update(updates)
            .eq('id', session_id)
            .single()
            .select()

        if (error) {
            console.error(error);
            return res.status(500).json({ error: 'Error updating session' });
        }

        return res.status(200).json({ message: 'Successfully updated session' });

    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
});


// DELETE: /api/sessions/{sessions_id}, delete session by session_id
router.delete('/:session_id', async (req, res) => {
    const session_id = req.params.session_id;

    try {
        const { data, error } = await supabase
            .from('sessions')
            .delete()
            .eq('id', session_id)
            .single()
            .select();

        if (error) {
            console.error(error);
            return res.status(404).json({ error: 'Session not found or could not be deleted' });
        }

        return res.status(200).json({ message: 'Session deleted successfully', user: data });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

// TODO: GET: /api/sessions/requester/{user_id}

// TODO: GET: /api/sessions/provider/{user_id}

module.exports = router;
