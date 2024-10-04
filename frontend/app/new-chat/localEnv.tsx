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

interface PageProps {
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
    changePage: (action: string)=>void,
    createChat: ()=>Promise<void>,
    dbms:string
}

export default function LocalEnvPage(
    {
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
        changePage,
        createChat,
        dbms
    }
    :PageProps
){
    const [isDisabled, setDisabled] = useState<boolean>(true)

    useEffect(()=>{
        if(hostName.trim() == "" || port.trim() == "" || user.trim() == "" || password.trim() == "" || database.trim() == ""){
            setDisabled(true)
        }
        else{
            setDisabled(false)
        }
    },[hostName, port, user, password, database])

    useEffect(()=>{
        if(dbms === 'postgresql'){
            setPort("5432")
        }
        else if(dbms === "mysql"){
            setPort("3306")
        }

    },[])

    return (

        <>
            <Card className="w-[350px]">
            <CardHeader>
                <CardTitle>Create New Chat</CardTitle>
                <CardDescription>Select your DB Configurations</CardDescription>
            </CardHeader>
            <CardContent>
                <form>
                <div className="grid w-full items-center gap-4">
                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="hostName">Enter Hostname</Label>
                        <Input id="hostName" value={hostName} placeholder="Enter Hostname" onChange={(e)=>{setHostName(e.target.value)}}  />
                    </div>

                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="port">Enter Port</Label>
                        <Input id="port" value={port} placeholder="Enter Port" onChange={(e)=>{setPort(e.target.value)}}  />
                    </div>

                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="user">Enter User</Label>
                        <Input id="user" value={user} placeholder="Enter User" onChange={(e)=>{setUser(e.target.value)}}  />
                    </div>

                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="password">Enter password</Label>
                        <Input id="password" value={password} type="password" placeholder="Enter Password" onChange={(e)=>{setPassword(e.target.value)}}  />
                    </div>

                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="database">Enter Database Name</Label>
                        <Input id="database" value={database} placeholder="Enter Database" onChange={(e)=>{setDatabase(e.target.value)}}  />
                    </div>
                </div>
                </form>
            </CardContent>
            <CardFooter className="flex justify-between">
                <Button variant="outline" onClick={(e)=>changePage("decrement")}>Back</Button>
                <Button onClick={
                    async (e)=>{ await createChat()}
                } 
                    disabled={isDisabled}
                >
                    Create Chat
                </Button>
            </CardFooter>
            </Card>
        </>
    )
}