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
    chatName: string;
    setChatName: Dispatch<SetStateAction<string>>;
    dbms: string;
    setDBMS: Dispatch<SetStateAction<string>>;
    environment:string,
    setEnvironment: Dispatch<SetStateAction<string>>;
    changePage: (action: string)=>void
}

export default function NewChatPage1(
    {
        chatName,
        setChatName,
        dbms,
        setDBMS,
        environment,
        setEnvironment,
        changePage
    }: PageProps
)
{
    const [isDisabled, setDisabled] = useState<boolean>(false)

    useEffect(()=>{
        if(chatName.trim()=="" || dbms.trim()=="" || environment.trim()==""){
            setDisabled(true)
        }
        else{
            setDisabled(false)
        }

    },[chatName, dbms, environment])

    return(
        <Card className="w-[350px]">
            <CardHeader>
                <CardTitle>Create New Chat</CardTitle>
                <CardDescription>Select your DB Configurations</CardDescription>
            </CardHeader>
            <CardContent>
                <div className="grid w-full items-center gap-4">
                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="chatName">Chat Name</Label>
                        <Input id="chatName" value={chatName} placeholder="Enter Chat Name" onChange={(e)=>{setChatName(e.target.value)}}  required/>
                    </div>
                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="dbms">Select DBMS</Label>
                        <Select value={dbms} onValueChange={(value)=>setDBMS(value)} required>
                            <SelectTrigger id="dbms">
                            <SelectValue placeholder="Select"/>
                            </SelectTrigger>
                            <SelectContent position="popper">
                            <SelectItem value="postgresql">PostgreSQL</SelectItem>
                            <SelectItem value="mysql">MySQL</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="environment">Select Environment</Label>
                        <Select value={environment} onValueChange={(value)=>setEnvironment(value)} required>
                            <SelectTrigger id="environment">
                            <SelectValue placeholder="Select"/>
                            </SelectTrigger>
                            <SelectContent position="popper">
                            <SelectItem value="local">Local</SelectItem>
                            <SelectItem value="cloud">Cloud</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                </div>
            </CardContent>
            <CardFooter className="flex justify-center">
                <Button onClick={(e)=>changePage("increment")} disabled={isDisabled}>Next</Button>
            </CardFooter>
            </Card>
    )
}