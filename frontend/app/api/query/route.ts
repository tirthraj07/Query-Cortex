import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest){
    const body = await request.json()

    if(!body.chat_id || !body.query || !body.model || !body.dbms || !body.host_name || !body.user || !body.password || !body.port){
        return NextResponse.json({error:"Insufficient Payload"}, {status:400})
    }

    const query = body.query;
    const model = body.model;
    const dbms = body.dbms;
    const credentials = {
        host: body.host_name,
        user: body.user,
        password: body.password,
        database: body.database,
        port: body.port
    }

    const payload = {
        query:query,
        model:"gemini",
        dbms:dbms,
        credentials:credentials
    }


    try{
        const response = await fetch(`${process.env.FAST_API_APP_URL}/api/query`,{
            method:'POST',
            headers:{
                'Content-Type':'application/json'
            },
            body:JSON.stringify(payload)
        })

        const responseData = await response.json()
        console.log(JSON.stringify(responseData))
        return NextResponse.json(responseData)
    }
    catch(error){
        console.log("Error occurred while request FAST API SERVER")
        console.error(error)
        return NextResponse.json({error:"Couldn't communicate with Server"},{status:500})
    }

}