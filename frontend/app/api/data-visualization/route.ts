import { NextRequest, NextResponse } from "next/server";

export async function POST(request:NextRequest){
    const requestedData = await request.json()
    // console.log(requestedData)

    for (const result of requestedData) {
        const payload = {
            "results": result
        };
    
        try {
            const fetchDataVisualization = await fetch(`${process.env.FAST_API_APP_URL}/api/data-visualization`, {
                method: "POST",
                headers: {
                    'Content-Type': "application/json"
                },
                body: JSON.stringify(payload)
            });
    
            if (!fetchDataVisualization.ok) {
                throw new Error(`HTTP error! Status: ${fetchDataVisualization.status}`);
            }
    
            const data = await fetchDataVisualization.json();
            console.log(data);

            

            return NextResponse.json(data,{status:200})

    
        } catch (error) {
            console.error("Error fetching data visualization:", error);
        }
    }
    

}