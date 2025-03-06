const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

//fetches one specific skill
router.get("/:id", async (req, res) =>{

    try{
        const id = req.params.id;

        const { data, error } = await supabase
        .from('skills')
        .select('*')
        .eq('id', id)
        .single();

        if(error){
            return res.status(400).send({error: error.message});
        }

        if(!data || data.length == 0){
            return res.status(404).send({message: "No skill ads found for this id."})
        }
        res.status(200).json(data);
    }
    catch (err){
        console.error(err);
        res.status(500).send({ error: "Internal server error"});
    };

});

// GET: /api/skills/recent/{limit}, returns the {limit} latest skill listings
router.get("/recent/:limit", async (req, res) => {
    const limit = req.params.limit;
    try {
        const { data, error } = await supabase
            .from('skills')
            .select("*")
            .order('created_at', { ascending: false })
            .limit(limit)

        if (error) {
            throw error;
        }

        res.status(200).json(data);
    } catch (err) {
        console.error(err);
        res.status(500).send({ error: "Internal server error"});
    }
});

// lists all listings in a specific category, and includes author
router.get("/category/:categoryName", async (req, res) => {
    try {
        const categoryName = req.params.categoryName;

        const { data, error } = await supabase
            .from('skills')
            .select(`*, users(username)`)
            .eq('category', categoryName);

        if (error) {
            throw error;
        }

        if (!data || data.length === 0) {
            return res.status(404).json({ message: "No listings found in this category" });
        }

        res.status(200).json(data);
    } catch (err) {
        console.error('Error fetching listings by category:', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});


//fetches all skills
router.get("/user/:user_id", async (req, res) =>{

try {
    const user_id = req.params.user_id;

    const { data, error } = await supabase
        .from('skills')
        .select('*')
        .eq('user_id', user_id);

        if(error){
            return res.status(400).send({error: error.message});
        }

        if(!data || data.length == 0){
            return res.status(404).send({message: "No skill ads found for this user."})
        }

        res.status(200).send(data);
}
catch (err){
    console.error(err);
    res.status(500).send({ error: "Internal server error"});
};


});

//adds a skill
router.post("/", async (req, res) => {
    try{
        const { user_id, name, description, created_at, category} = req.body;

        if(!user_id || !name || !description || !created_at || !category) {
            return res.status(400).send({ error: "Missing required fields"});

        }

        const { data, error } = await supabase
            .from("skills")
            .insert([
                {
                    user_id,
                    name,
                    description,
                    created_at,
                    category,
                },
            ]);
        if(error){
            return res.status(400).send({ error: error.message});
        }

        res.status(201).send({
            message: "Skill added succesfully",
           
        });
    }catch (err){
        console.error(err);
        res.status(500).send({error: "Internal server error"});
    }
});

//deletes a skill
router.delete("/:name/:user_id", async (req, res) => {
    try {
        const { name, user_id } = req.params; 

     
        if (!name || !user_id) {
            return res.status(400).send({ error: "Name and id is required" });
        }

      
        const { data, error } = await supabase
            .from("skills")
            .delete()
            .eq("name", name)
            .eq("user_id", user_id);
            
       
        if (error) {
            return res.status(400).send({ error: error.message });
        }

      
        if ( !data || !data.length || data.length === 0) {
            return res.status(404).send({ error: "Skill not found" });
        }

       
        res.status(200).send({
            message: "Skill deleted successfully",
        });
    } catch (err) {
        console.error(err);
        res.status(500).send({ error: "Internal server error" });
    }
});


//checks if skillname exists
router.get("/:name/:user_id", async (req, res) => {
    try {
        const { name, user_id } = req.params; 

     
        if (!name || !user_id) {
            return res.status(400).send({ error: "Name and id is required" });
        }

      
        const { data, error } = await supabase
            .from("skills")
            .select("*")
            .eq("name", name)
            .eq("user_id", user_id);
            
       
        if (error) {
            return res.status(400).send({ error: error.message });
        }

      
        if (!data || data.length === 0) {
            return res.status(404).send({ error: "Skill not found" });
        }

       
        res.status(200).send({
            message: "Skill found successfully",
        });
    } catch (err) {
        console.error(err);
        res.status(500).send({ error: "Internal server error" });
    }
});

//fetches all skills that match either name or description
router.get("/search/:search", async (req, res) => {
    try {
        const search = req.params.search;

        if (!search || typeof search !== 'string') {
            return res.status(400).send({ error: 'Invalid search term' });
        }
    
        const { data, error } = await supabase
            .rpc('search_skills', {
                search_term: search
            });
    
            if(error){
                console.error("RPC error: ", error);
                return res.status(400).send({error: error.message});
            }
    
            if(!data || data.length == 0){
                return res.status(404).send({message: "No skill ads found for this user."})
            }
    
            res.status(200).send(data);
    }
    catch (err) {
        console.error(err);
        res.status(500).send({ error: "Internal server error"});
    };
});

module.exports = router;
