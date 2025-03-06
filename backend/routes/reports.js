const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

// GET: /api/reports, fetches ALL reports
router.get('/', async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('reports')
            .select('*')
            .order('created_at', { ascending: false });

        if (error) {
            res.status(400).json({ 'error': error });
            throw error;
        }
        
        res.status(200).json(data);
    } catch (err) {
        console.error('Error fetching reports: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// DELETE: /api/reports/{report_id}, deletes report (no resolving)
router.delete('/:report_id', async (req, res) => {
    const report_id = req.params.report_id;

    try {
        const { data, error } = await supabase
            .from('reports')
            .delete()
            .eq('id', report_id);

        if (error) {
            return res.status(400).json({ error: error });
            throw error;
        }

        return res.status(200).json({ message: 'Successfully removed report' });
    } catch (err) {
        console.error('Error fetching reports: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// DELETE: /api/reports/resolve/{report_id}, deletes report & resolves (deletes) skill
router.delete('/resolve/:report_id', async (req, res) => {
    const report_id = req.params.report_id;

    try {
        // step 1: fetch report
        const { data: report_data, error: report_error } = await supabase
            .from('reports')
            .select('*')
            .eq('id', report_id)
            .single();

        if (report_error) {
            throw report_error;
        }

        const report = report_data;
        
        // step 2: call database function to remove both atomically
        const { data, error } = await supabase
            .rpc('delete_report_and_skill', {
                report_id_param: report['id'],
                skill_id_param: report['skill_id']
            });

        if (error) {
            throw error;
        }

        return res.status(200).json({ message: 'Successfully removed listing and report'});
    } catch (err) {
        console.error('Error fetching reports: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
}); 

// POST: /api/reports, create new report
router.post('/', async (req, res) => {
    const { skill_id, text } = req.body;

    try {
        const { data: exists_data, error: exists_error } = await supabase
            .from('reports')
            .select('*')
            .eq('skill_id', skill_id)
            .single();

        if (exists_error && exists_error.code !== "PGRST116") {
            res.status(400).json({ error: exists_error });
            throw exists_error;
        }

        if (exists_data) {
            return res.status(200).json(exists_data);
        }

        const { data, error } = await supabase
            .from('reports')
            .insert({
                skill_id: skill_id,
                text: text
            })
            .select()
            .single();

        if (error) {
            res.status(400).json({ 'error': error });
            throw error;
        }

        res.status(200).json(data);
    } catch (err) {
        console.error('Error fetching reports: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
