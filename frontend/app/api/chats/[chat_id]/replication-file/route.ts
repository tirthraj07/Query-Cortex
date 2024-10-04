import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest, { params }:{
    params:{
        chat_id:string
    }
}){
    const formData = await request.formData();
    if(formData.get('file')){
        const file = formData.get('file') as File;
        
        const newFormData = new FormData()
        newFormData.append('file',file)
        const chat_id = params.chat_id;

        const response = await fetch(`${process.env.FLASK_APP_URL}/api/chats/${chat_id}/replication-file`,{
            method:'POST',
            body: newFormData
        })

        const data = await response.json()

        return NextResponse.json(data)

    }

    return NextResponse.json({error:"File not found"}, {status: 404})
}