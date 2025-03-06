const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

// returns a simple message to check whether server is running or not (& connection is made)
router.get("", async (req, res) => {
    let { data, error } = await supabase
        .rpc('status')
    if (error) console.error(error)
    else res.status(200).json({'status': `express backend running | ${data}`});
});

module.exports = router;
