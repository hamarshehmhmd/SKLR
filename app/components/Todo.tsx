import { useEffect, useState } from 'react'
import { supabase } from '../utils/supabase'

interface Todo {
    id: number
    text: string
    completed: boolean
    created_at: string
}

export default function Todo() {
    const [todos, setTodos] = useState<Todo[]>([])
    const [newTodo, setNewTodo] = useState('')
    const [loading, setLoading] = useState(true)

    const fetchTodos = async () => {
        try {
            const { data, error } = await supabase
                .from('todos')
                .select('*')
                .order('created_at', { ascending: false })

            if (error) {
                throw error
            }

            if (data) {
                setTodos(data)
            }
        } catch (error) {
            console.error('Error fetching todos:', error)
        } finally {
            setLoading(false)
        }
    }

    useEffect(() => {
        fetchTodos()
        
        // Set up real-time subscription
        const channel = supabase
            .channel('todos_channel')
            .on(
                'postgres_changes',
                {
                    event: '*',
                    schema: 'public',
                    table: 'todos'
                },
                (payload: any) => {
                    console.log('Real-time change received:', payload)
                    switch (payload.eventType) {
                        case 'INSERT':
                            setTodos(currentTodos => [...currentTodos, payload.new as Todo])
                            break
                        case 'UPDATE':
                            setTodos(currentTodos =>
                                currentTodos.map(todo =>
                                    todo.id === payload.new.id ? { ...payload.new as Todo } : todo
                                )
                            )
                            break
                        case 'DELETE':
                            setTodos(currentTodos =>
                                currentTodos.filter(todo => todo.id !== payload.old.id)
                            )
                            break
                    }
                }
            )
            .subscribe()

        // Cleanup subscription on component unmount
        return () => {
            supabase.channel('todos_channel').unsubscribe()
        }
    }, [])

    // Test functions
    const testRealtime = async () => {
        try {
            // Test INSERT
            const { data: insertData, error: insertError } = await supabase
                .from('todos')
                .insert({
                    text: 'Test real-time ' + new Date().toLocaleTimeString(),
                    completed: false,
                })
                .select()
            
            if (insertError) throw insertError
            console.log('Test: Inserted todo', insertData)

            // Wait 2 seconds before update
            if (insertData) {
                setTimeout(async () => {
                    // Test UPDATE
                    const { error: updateError } = await supabase
                        .from('todos')
                        .update({ completed: true })
                        .eq('id', insertData[0].id)

                    if (updateError) throw updateError
                    console.log('Test: Updated todo')

                    // Wait 2 seconds before delete
                    setTimeout(async () => {
                        // Test DELETE
                        const { error: deleteError } = await supabase
                            .from('todos')
                            .delete()
                            .eq('id', insertData[0].id)

                        if (deleteError) throw deleteError
                        console.log('Test: Deleted todo')
                    }, 2000)
                }, 2000)
            }
        } catch (error) {
            console.error('Test error:', error)
        }
    }

    return (
        <div className="p-4">
            <button
                onClick={testRealtime}
                className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
                Test Real-time
            </button>
        </div>
    )
} 