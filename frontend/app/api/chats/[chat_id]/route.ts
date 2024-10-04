import { NextRequest, NextResponse } from "next/server";


export async function GET(NextRequest:Request, { params }:{
    params:{
        chat_id:string
    }
}){

    const chat_id = params.chat_id;

    const fetchCredentials = await fetch(`${process.env.FLASK_APP_URL}/api/chats/${chat_id}/credentials`,{
        method:'GET'
    })

    const fetchCredentialsData = await fetchCredentials.json()

    if(fetchCredentialsData.error){
        console.log(`INVALID CHAT ID: ${chat_id}`)
        return NextResponse.json({error:"Invalid Chat"}, {status:404})
    }

    const credentials = {
        chat_id: fetchCredentialsData.chat_id,
        chat_name: fetchCredentialsData.chat_name,
        dbms: fetchCredentialsData.dbms,
        host_name: fetchCredentialsData.host_name,
        environment: fetchCredentialsData.environment,
        user: fetchCredentialsData.user,
        password: fetchCredentialsData.password,
        database: fetchCredentialsData.database,
        port: fetchCredentialsData.port
    }

    return NextResponse.json({success:"Credentials Obtained successfully", credentials:credentials}, {status: 200})

}