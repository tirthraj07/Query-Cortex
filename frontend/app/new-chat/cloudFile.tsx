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
    changePage: (action: string)=>void,
    createCloudChat: ()=>Promise<void>,
    replicationFile: File| null | undefined,
    setReplicationFile: Dispatch<SetStateAction<File|null|undefined>>
    handleFileChange:(event: React.ChangeEvent<HTMLInputElement>) => void    
}

export default function CloudFilePage(
    {
        changePage,
        createCloudChat,
        replicationFile,
        setReplicationFile,
        handleFileChange
    }
    :PageProps
){
    const [isDisabled, setDisabled] = useState<boolean>(true)

    useEffect(()=>{
        if(replicationFile){
            setDisabled(false)
        }
        else{
            setDisabled(true)
        }
    },[replicationFile])

    return (

        <>
            <Card className="w-[350px]">
            <CardHeader>
                <CardTitle>Upload Replication File</CardTitle>
                <CardDescription>Run the following command to get the replica: <code>pg_dump -F p -U postgres -d &lt;db-name&gt; -f replica.sql</code></CardDescription>
            </CardHeader>
            <CardContent>
                <form>
                <div className="grid w-full items-center gap-4">
                    <div className="flex flex-col space-y-1.5">
                        <Label htmlFor="hostName">Upload File</Label>
                        <Input id="hostName" type="file" onChange={handleFileChange}  />
                    </div>
                </div>
                </form>
            </CardContent>
            <CardFooter className="flex justify-between">
                <Button variant="outline" onClick={(e)=>changePage("decrement")}>Back</Button>
                <Button onClick={
                    async (e)=>{ await createCloudChat()}
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