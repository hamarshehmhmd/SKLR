const express = require("express");
const supabase = require("../db/supabase");
const router = express.Router();

//gets chats for homepage : lastmessage, lastupdated
router.get("/user/:userId", async (req, res) =>{

    const userId = parseInt(req.params.userId, 10);
    const { data, error } = await supabase
        .from('chats')
        .select(`id, user1_id, user2_id, last_message, last_updated, sessions(skill_id, skills(name))`)
        .or(`user1_id.eq.${userId},user2_id.eq.${userId}`)
        .order('last_updated', { ascending: false });

        if (error) {
        console.error('Error fetching chats:', error);
        }
        const formattedData = data.map(chat => ({
            chat_id: chat.id,
            last_message: chat.last_message,
            last_updated: chat.last_updated,
            skill: chat.sessions.skills.name,
            other_user_id: chat.user1_id === userId ? chat.user2_id : chat.user1_id,
        }));
        res.status(200).json(formattedData);
});

//getting messages in a chat
router.get("/:chatId/messages", async (req, res) => {
    const chatId = req.params.chatId;
    const {data, error} = await supabase
        .from('messages')
        .select('*')
        .eq('chat_id', chatId)
        .order('timestamp', {ascending: true});

    if(error){
        console.error("Error fetching messages: ", error);
        return res.status(500).json({error: error.messages});
    }

    res.status(200).json(data);
});

//creates or finds chat for user
router.post("/get-or-create", async (req, res) => {
    const { user1Id, user2Id, session_id } = req.body;

    const {data: existingChat, error: findError} = await supabase
        .from('chats')
        .select('*')
        .or(
            `and(user1_id.eq.${user1Id}, user2_id.eq.${user2Id}, session_id.eq.${session_id}),and(user1_id.eq.${user2Id}, user2_id.eq.${user1Id}, session_id.eq.${session_id})`
        )
        .limit(1);

    if(findError){
        console.error("Error checking chat: ", findError);
        return res.status(500).json({error: findError.message});
    }

    if(existingChat.length > 0) {
        return res.status(200).json({chat_id: existingChat[0].id});
    }

    const { data:newChat, error: createError } = await supabase
        .from('chats')
        .insert({
            user1_id: user1Id,
            user2_id: user2Id,
            session_id: session_id,
            last_message: null,
            last_updated: new Date().toISOString(),
        })
        .select();

    console.log(newChat);

    if(createError){
        console.error("Error creating chat: ", createError);
        return res.status(500).json({error: createError.message});
    }

    res.status(200).json({chat_id: newChat[0].id});
});

//sends chat
router.post("/:chatId/message", async (req, res) => {
    const chatId = req.params.chatId;
    const { senderId, message} = req.body;

    const { error: messageError } = await supabase
        .from('messages')
        .insert({
            chat_id: chatId,
            sender_id: senderId,
            message: message,
            timestamp: new Date().toISOString(),
        });

    if(messageError){
        console.error("Error sending a chat: ", messageError)
        return res.status(500).json({error: messageError.message});
    }

    const { error: updateError} = await supabase
        .from('chats')
        .update({
            last_message: message,
            last_updated: new Date().toISOString(),
        })
        .eq('id', chatId);
    
    if(updateError){
        console.error("Error updating chat:", updateError);
        return res.status(500).json({error: updateError});
    }

    res.status(200).json({ success: true});
});

// GET: /api/chat/session/{chat_id}
router.get("/session/:chatId", async (req, res) => {
    const chatId = req.params.chatId;

    try {
        // step 1: fetch session_id from 'chats'
        const { data: chat_data, error: chat_error } = await supabase
            .from('chats')
            .select('session_id')
            .eq('id', chatId)
            .single();

        if (chat_error) {
            throw chat_error;
        }

        if (!chat_data || !chat_data['session_id']) {
            throw new Error('No session_id found for the given chat_id');
        }

        const sessionId = chat_data['session_id'];

        // step 2: fetch * from 'sessions'
        const { data, error } = await supabase
            .from('sessions')
            .select("*")
            .eq('id', sessionId)
            .single();

        if (error) {
            throw error;
        }

        res.status(200).json(data);
    } catch (err) {
        console.error('Error fetching user: ', err.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
