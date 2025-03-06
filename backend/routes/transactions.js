const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

// GET: /api/transactions/{transaction_id}, fetch transaction by id
router.get('/:transaction_id', async (req, res) => {
    const transaction_id = req.params.transaction_id;

    try {
        const { data, error } = await supabase
            .from('transactions')
            .select("*")
            .eq('id', transaction_id)
            .single();

        if (error) {
            throw error;
        }

        return res.status(200).json(data);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
}); 

// GET: /api/transactions/session/{session_id}
router.get('/session/:session_id', async (req, res) => {
    const session_id = req.params.session_id;

    try {
        const { data, error } = await supabase
            .from('transactions')
            .select("*")
            .eq('session_id', session_id)
            .single();

        if (error) {
            return res.status(404).json(error);
        }

        return res.status(200).json(data);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
}); 

// POST: /api/transactions, create transaction (proof of payment)
router.post('/', async (req, res) => {
    const { session_id } = req.body;

    if (!session_id) {
        res.status(404).json({ error: 'Could not find session' });
    }

    try {
        // step 1: find requester & provider of session
        const { data: session_data, error: session_error } = await supabase
            .from('sessions')
            .select('requester_id, provider_id')
            .eq('id', session_id)
            .single();

        if (session_error) {
            throw session_error;
        }

        // step 2: create transaction through rpc
        const { data, error } = await supabase
            .rpc('create-transaction', { 
                requester_id: session_data['requester_id'],
                provider_id: session_data['provider_id'],
                session_id: session_id, 
            });

        if (error) {
            throw error;
        }

        return res.status(201).json({ message: 'Transaction created successfully' });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
}); 

// DELETE: /api/transactions/{transaction_id}, delete transaction
router.delete('/:transaction_id', async (req, res) => {
    const transaction_id = req.params.transaction_id;

    try {
        const { data, error } = await supabase
            .from('transactions')
            .delete()
            .eq('id', transaction_id)
            .single()
            .select();

        if (error) {
            throw error;
        }

        return res.status(200).json({ message: 'Transaction deleted successfully', user: data });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
}); 

// POST: /api/transactions/finalize
router.post('/finalize', async (req, res) => {
    const { provider_id, session_id, transaction_id } = req.body;

    if (!provider_id || !session_id || !transaction_id) {
        return res.status(400).json({'error': 'missing parameters'});
    }

    try {
        const { data, error } = await supabase
            .rpc('finalize-transaction', {
                provider_id: provider_id,
                session_id: session_id,
                transaction_id: transaction_id
            });

        if (error) {
            throw error;
        }

        res.status(200).json(data);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal server error' });
    }
}); 

module.exports = router;
