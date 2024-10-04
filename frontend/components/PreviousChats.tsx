"use client"
import {useEffect, useState} from 'react';
import Link from "next/link"
 
import { Button } from "@/components/ui/button"
interface Chat {
  chat_id: string,
  chat_name: string
}

export default function PreviousChats() {
  const [chats, setChats] = useState<Array<Chat>>([]) 
  
  useEffect(()=>{
    const requestForChats = async ()=>{
      try{
      const response = await fetch('/api/chats',{
        method:'GET'
      })
      
      const data = await response.json()

      if(!data.chats){
        console.log(data);
        throw new Error('No chats object in response')
      }
      else{

        const user_chats = Array<Chat>();
        
        for(let user_chat of data.chats){
          user_chats.push({chat_id:user_chat.chat_id, chat_name:user_chat.chat_name})
        }
        setChats(user_chats)
      }
      
      }
      catch(error){
        alert('Unable to Load Chats')
        console.log(error)
      }

    }

    requestForChats()

  },[])

  return (
    <div className="w-1/6 p-4 border-r h-screen overflow-y-auto bg-gray-50">
      <h2 className="text-xl font-bold mb-7 text-gray-800">Query Cortex</h2>      

      <Button variant={'default'} className='w-full text-base'>
                <Link href={'/new-chat'}>Start New Chat</Link>
      </Button>

      <h2 className="text-lg font-bold mb-4 mt-5 text-gray-800">Previous Chats</h2>
      <div className="space-y-2">
        {/* <li className="flex items-center p-2 rounded-lg bg-white shadow-sm cursor-pointer transition duration-200 hover:bg-blue-100 hover:text-blue-600">
          Chat 1
        </li> */}
        {
          chats &&
          chats.map((chat:Chat)=>{
            return (
              <Button asChild key={chat.chat_id} variant={'ghost'} className='w-full text-base'>
                <Link href={`/chats/${chat.chat_id}`}>{chat.chat_name}</Link>
              </Button>
            )
          })
        }

      </div>
    </div>

  );
}
