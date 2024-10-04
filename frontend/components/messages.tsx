import Image from "next/image"
import {
    Table,
    TableBody,
    TableCaption,
    TableCell,
    TableFooter,
    TableHead,
    TableHeader,
    TableRow,
  } from "@/components/ui/table"


export function clientMessage(message:string){
    return(
        <div className="w-full flex flex-row-reverse">
            <div className="p-2 mb-2 bg-blue-600 text-white rounded-md">
                {message}
            </div>
        </div>
    )
}

export function assistantTextMessage(message: string){
    return(
        <div className="w-full flex flex-row">
            <div className="p-2 mb-2 bg-gray-100 rounded-md">
                {message}
            </div>
        </div>
    )
}

export function assistantQueryMessage(message: string){
    return(
        <div className="w-full flex flex-row">
            <div className="p-2 mb-2 bg-black rounded-md ps-5 pe-5 text-gray-100">
                <code>
                    {message}
                </code>
            </div>
        </div>
    )
}

export function assistantImageMessage(url: string){
    return (
        <div className="p-2 mb-2 rounded-md">
        <Image 
            src={url}
            width={300}
            height={300}
            className="rounded-t-3xl"
            style={{
                objectFit:'cover'
            }}
            alt={""}
        />
        </div>
    )
}

interface TableRowData {
    [key: string]: any;
}

export function assistantTableMessage(array:TableRowData[]){
    return(
        <div className="flex flex-row w-full mt-3 mb-3">
        <div className="p-2 mb-2 bg-slate-50 rounded-md ps-5 pe-5 border border-gray-500">

            <Table>
                <TableCaption>Requested Data</TableCaption>
                <TableHeader>
                    <TableRow>
                        {Object.keys(array[0]).map((key) => (
                            <TableHead className="w-[100px]" key={key}>{key}</TableHead>
                        ))}
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {array.map((row, row_number:number) => (
                    <TableRow key={row_number}>
                        {Object.values(row).map((value, index) => (
                        <TableCell key={index}>{value}</TableCell>
                        ))}
                    </TableRow>
                    ))}
                </TableBody>
            </Table>

        </div>
        </div>
    )
}