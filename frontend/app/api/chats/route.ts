import { NextRequest, NextResponse } from "next/server";

export async function POST(request:NextRequest){
    const requestBody = await request.json(); 

    const response = await fetch(`${process.env.FLASK_APP_URL}/api/chats`,{
        method:'POST',
        headers:{
            'Content-Type':'application/json'
        },
        body:JSON.stringify(requestBody)
    })

    const responseData = await response.json();

    return NextResponse.json(responseData)

}

export async function GET(request: NextRequest){

    const response = await fetch(`${process.env.FLASK_APP_URL}/api/chats`,{
        method:'GET'
    })

    const responseData = await response.json();

    return NextResponse.json(responseData)


}