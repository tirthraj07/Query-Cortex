"use client"
import ChatArea from "@/components/ChatArea";
import DropdownMenu from "@/components/DropdownMenu";
import NewChat from "@/components/NewChat";
import PreviousChats from "@/components/PreviousChats";
import { useState, useEffect } from "react";

interface DBCredentials {
    "chat_id": string,
    "chat_name": string,
    "database": string,
    "dbms": string,
    "environment": string,
    "host_name": string,
    "password": string,
    "port": string,
    "user": string
}

export interface TableRowData {
    [key: string]: any;
}


export interface MessageType {
    role: "assistant" | "user",
    content: string | TableRowData[],
    content_type:string
}

export default function ChatIdPage({params}:{
    params: {chat_id:string}
}){
    const [llmModel, setLLMModel] = useState<string>("gemini")

    const [messages, setMessages] = useState<MessageType[]>([]);

    const [input, setInput] = useState<string>("");

    const [dbCredentials, setDBCredentials] = useState<DBCredentials>();

    const [isButtonDisabled, setIsButtonDisabled] = useState<boolean>(false);

    const [isInsightsButtonDisabled, SetInsightsButtonDisabled] = useState<boolean>(true)

    const [results, setResults] = useState<TableRowData[][]>([])

    useEffect(()=>{

        const requestCredentials = async() =>{
            try{
                const response = await fetch(`/api/chats/${params.chat_id}`, {
                    method:'GET'
                });
                
                const data = await response.json()
                const data_credentials = data.credentials;

                if(data.error){
                    console.log(data.error)
                    alert(data.error)
                    window.location.href = '/new-chat'
                }
                else{
                    const credentials: DBCredentials = {
                        chat_id: data_credentials.chat_id,
                        chat_name: data_credentials.chat_name,
                        database: data_credentials.database,
                        dbms: data_credentials.dbms,
                        environment: data_credentials.environment,
                        host_name: data_credentials.host_name,
                        password: data_credentials.password,
                        port: data_credentials.port,
                        user: data_credentials.user
                    }

                    setDBCredentials(credentials)
                }
            }
            catch(error){
                alert(error)
                window.location.href = '/new-chat'
            }
            
        }

        requestCredentials()
    },[])

    useEffect((
    )=>{
        console.log(results)
        if(results.length != 0){
            SetInsightsButtonDisabled(false)   
        }
        else{
            SetInsightsButtonDisabled(true)
        }
    },[results])

    useEffect(()=>{
        console.log(messages)
    },[messages])

    async function getInsights(){
        if(results.length != 0){
            SetInsightsButtonDisabled(true)

            const response = await fetch('/api/data-visualization', {
                method:"POST",
                headers:{
                    'Content-Type':"application/json"
                },
                body:JSON.stringify(results)
            })

            const data = await response.json()
            console.log(data)
            if(data.response && data.response.length > 0){
                data.response.forEach((response)=>{
                    if(response.Insights && response.Insights.length > 0){
                        response.Insights.forEach((insight:string)=>{
                            console.log(insight)
                            let queryMessage: MessageType = {
                                role:"assistant",
                                content:insight,
                                content_type:"text"
                            }
                            // Use the functional update form to append the new message
                            setMessages(prevMessages => [...prevMessages, queryMessage]);
                        })
                    }
                })
            }
            
            if(data.image_urls && data.image_urls.length > 0){
                data.image_urls.forEach((image_url:string)=>{
                    console.log(image_url)
                    let queryMessage: MessageType = {
                        role:"assistant",
                        content:image_url,
                        content_type:"image"
                    }
                    // Use the functional update form to append the new message
                    setMessages(prevMessages => [...prevMessages, queryMessage]);
                })
            }
            
            SetInsightsButtonDisabled(false)
        }
    }


    const sendUserMessage = (user_message:string) => {
        if (user_message.trim()) {
            const msg: MessageType = {
                role:"user",
                content:user_message,
                content_type:"text"
            }
            setMessages([...messages, msg])
        }
    };

    async function sendQuery(){
        if(input.trim()==""){
            return
        }
        const message = input
        sendUserMessage(message)
        setInput('');
        setIsButtonDisabled(true)
        try{
            const response = await fetch('/api/query',{
                method:'POST',
                headers: {
                    'Content-Type':'application/json'
                },
                body: JSON.stringify({...dbCredentials, query: message.trim(), model:llmModel})
            })
            const data = await response.json()

            if(data.query && data.query.length > 0){
                data.query.forEach((query:string)=>{
                    console.log(query)
                    let queryMessage: MessageType = {
                        role:"assistant",
                        content:query,
                        content_type:"query"
                    }
                    // Use the functional update form to append the new message
                    setMessages(prevMessages => [...prevMessages, queryMessage]);
                })
            }

            if(data.results && data.results.length > 0){
                setResults(data.results)
                data.results.forEach((table:TableRowData[])=>{
                    let tableMessage:MessageType = {
                        role:"assistant",
                        content:table,
                        content_type:"table"
                    }
                    // Use the functional update form to append the new message
                    setMessages(prevMessages => [...prevMessages, tableMessage]);
                })
            }

        }
        catch(error){
            console.log(error)
            alert(error)
        }
        finally{
            setIsButtonDisabled(false)
        }

    }

    return (
        <>
            <div className="flex h-screen">
                <PreviousChats />

                <div className="w-5/6 flex flex-col">
                    <div className="flex justify-between items-center p-4 border-b h-[10vh]">
                        <DropdownMenu llmModel={llmModel} setLLMModel={setLLMModel}/>
                    </div>

                    <ChatArea
                        sendQuery={sendQuery}
                        messages={messages}
                        input={input}
                        setMessages={setMessages}
                        setInput={setInput}
                        sendUserMessage={sendUserMessage}
                        isButtonDisabled={isButtonDisabled}
                        getInsights={getInsights}
                        isInsightsButtonDisabled={isInsightsButtonDisabled}
                    />
                </div>
            </div> 
        </>
    )
}
