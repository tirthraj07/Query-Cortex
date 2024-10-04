"use client"
import DropdownMenu from "@/components/DropdownMenu";
import NewChat from "@/components/NewChat";
import PreviousChats from "@/components/PreviousChats";
import { useState } from "react";

export default function ChatPage() {
    const [llmModel, setLLMModel] = useState<string>("gemini")
    const [chatName, setChatName] = useState<string>("New-Chat")
    const [hostName, setHostName] = useState<string>("")
    const [port, setPort] = useState<string>("")
    const [user, setUser] = useState<string>("")
    const [password, setPassword] = useState<string>("")
    const [database, setDatabase] = useState<string>("")
    const [dbms, setDBMS] = useState<string>("postgresql")
    const [environment, setEnvironment] = useState<string>("local")
    const [replicationFile, setReplicationFile] = useState<File | null>();


    return (
      <div className="flex h-screen">
        <PreviousChats />
  
        <div className="w-5/6 flex flex-col">
          {/* <div className="flex justify-between items-center p-4 border">
            <DropdownMenu llmModel={llmModel} setLLMModel={setLLMModel}/>
          </div> */}
  
          <NewChat 
            chatName={chatName} setChatName={setChatName} 
            hostName={hostName} setHostName={setHostName} 
            port={port} setPort={setPort} 
            user={user} setUser={setUser} 
            password={password} setPassword={setPassword} 
            database={database} setDatabase={setDatabase} 
            dbms={dbms} setDBMS={setDBMS} 
            environment={environment} setEnvironment={setEnvironment}
            replicationFile={replicationFile} setReplicationFile={setReplicationFile}
          />
        </div>
      </div>
    );
  }