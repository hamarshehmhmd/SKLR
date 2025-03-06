const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

// GET: /api/categories, fetch ALL categories
router.get("", async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('categories')
            .select("*")
        
        if (error) {
            throw error;
        }

        res.status(200).json(data);
    } catch (err) {
        console.error('Error fetching users: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
}); 

module.exports = router;
