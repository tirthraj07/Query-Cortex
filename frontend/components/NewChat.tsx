"use client"
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Button } from "@/components/ui/button"

import React, { Dispatch, SetStateAction, useState, useEffect } from "react";
import NewChatPage1 from "@/app/new-chat/page1"
import LocalEnvPage from "@/app/new-chat/localEnv"
import CloudEnvPage from "@/app/new-chat/cloudEnv"
import CloudFilePage from "@/app/new-chat/cloudFile"  

interface NewChatProps {
    chatName: string;
    setChatName: Dispatch<SetStateAction<string>>;
    hostName: string;
    setHostName: Dispatch<SetStateAction<string>>;
    port: string;
    setPort: Dispatch<SetStateAction<string>>;
    user: string;
    setUser: Dispatch<SetStateAction<string>>;
    password: string;
    setPassword: Dispatch<SetStateAction<string>>;
    database: string;
    setDatabase: Dispatch<SetStateAction<string>>;
    dbms: string;
    setDBMS: Dispatch<SetStateAction<string>>;
    environment:string,
    setEnvironment: Dispatch<SetStateAction<string>>;
    replicationFile: File| null | undefined,
    setReplicationFile: Dispatch<SetStateAction<File|null|undefined>>
}

export default function NewChat({
        chatName,
        setChatName,
        hostName,
        setHostName,
        port,
        setPort,
        user,
        setUser,
        password,
        setPassword,
        database,
        setDatabase,
        dbms,
        setDBMS,
        environment,
        setEnvironment,
        replicationFile,
        setReplicationFile
    }:  NewChatProps
) 
{

    const [page, SetPage] = useState<number>(1);

    function changePage(action:string){
        if(action==="increment"){
            SetPage(page + 1)
        }
        else if(action=="decrement" && page>1){
            SetPage(page-1);
        }
    }

    async function createChat(){

        const payload = {
            chat_name: chatName,
            host_name: hostName,
            port:port,
            user:user,
            password:password,
            database:database,
            dbms:dbms,
            environment:environment
        }

        const response = await fetch('/api/chats',{
            method:'POST',
            headers:{
                'Content-Type':'application/json'
            },
            body:JSON.stringify(payload)
        })

        const data = await response.json()

        if(data.error){
            alert(data.error)
            console.log(data.error)
        }
        else if(data.success){
            alert(data.success)
            window.location.href = `/chats/${data.chat_id}`
        }

    }

    function handleFileChange(event: React.ChangeEvent<HTMLInputElement>) {
        if (event.target.files && event.target.files.length > 0) {
            const file = event.target.files[0];
            setReplicationFile(file);
        }
        else{
            setReplicationFile(null)
        }
    }

    async function createCloudChat(){
        console.log("Button Clicked")
        console.log(replicationFile)

        const payload = {
            chat_name: chatName,
            host_name: hostName,
            port:port,
            user:user,
            password:password,
            database:database,
            dbms:dbms,
            environment:environment
        }

        const response = await fetch('/api/chats',{
            method:'POST',
            headers:{
                'Content-Type':'application/json'
            },
            body:JSON.stringify(payload)
        })

        const data = await response.json()

        if(data.error){
            alert(data.error)
            console.log(data.error)
        }
        else if(data.success && replicationFile){

            const formData = new FormData();    
            formData.append('file', replicationFile);

            const chat_id = data.chat_id;
            const uploadReplicaFileResponse = await fetch(`/api/chats/${chat_id}/replication-file`,{
                method:'POST',
                body: formData
            })
            
            const uploadReplicaFileData = await uploadReplicaFileResponse.json();
            if(uploadReplicaFileData.error){
                console.log(uploadReplicaFileData.error)
                alert(uploadReplicaFileData.error)
            }
            
            else if(uploadReplicaFileData.success){
                alert(data.success)
                window.location.href = `/chats/${data.chat_id}`  
            }

        }

    }


    return (
    <div className="w-full p-4 flex flex-col justify-center items-center h-screen">

        {
            page==1
            &&
            <NewChatPage1 
                chatName={chatName} setChatName={setChatName} 
                dbms={dbms} setDBMS={setDBMS} 
                environment={environment} setEnvironment={setEnvironment}
                changePage={changePage}
            />
        }

        {
            page==2
            &&
            environment=="local"
            &&
            <LocalEnvPage  
                hostName={hostName} setHostName={setHostName} 
                port={port} setPort={setPort} 
                user={user} setUser={setUser} 
                password={password} setPassword={setPassword} 
                database={database} setDatabase={setDatabase} 
                changePage={changePage}
                createChat={createChat}
                dbms={dbms}
            />
        }

        {
            page == 2
            &&
            environment == "cloud"
            &&
            <CloudEnvPage
                hostName={hostName} setHostName={setHostName} 
                port={port} setPort={setPort} 
                user={user} setUser={setUser} 
                password={password} setPassword={setPassword} 
                database={database} setDatabase={setDatabase} 
                changePage={changePage}
                dbms={dbms}
            />
        }

        {
            page==3
            &&
            environment=="cloud"
            &&
            <CloudFilePage
                changePage={changePage}
                createCloudChat={createCloudChat}
                handleFileChange={handleFileChange}
                replicationFile={replicationFile}
                setReplicationFile={setReplicationFile}

            />

        }

    </div>
    );
}
