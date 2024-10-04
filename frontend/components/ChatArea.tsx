"use client"
import { useState, Dispatch, SetStateAction, useEffect } from 'react';
import { Button } from "@/components/ui/button"
import { MessageType, TableRowData } from '@/app/chats/[chat_id]/page';
import { clientMessage, assistantTableMessage, assistantQueryMessage, assistantImageMessage, assistantTextMessage } from "@/components/messages"

export default function ChatArea(
  {
    sendQuery,
    messages,
    setMessages,
    input,
    setInput,
    sendUserMessage,
    isButtonDisabled,
    getInsights,
    isInsightsButtonDisabled
  }:
  {
    sendQuery:()=>Promise<void>,
    messages:MessageType[],
    input:string,
    setMessages:Dispatch<SetStateAction<MessageType[]>>,
    setInput:Dispatch<SetStateAction<string>>,
    sendUserMessage:(user_message:string)=>void,
    isButtonDisabled:boolean,
    getInsights: ()=>Promise<void>,
    isInsightsButtonDisabled: boolean
  }

) {

  useEffect(() => {
      const messageBox = document.getElementById('message-box');
      if (messageBox) {
          messageBox.scrollTop = messageBox.scrollHeight; // Scroll to the bottom
      }
  }, [messages]);

  return (
    <div className="w-full p-4 flex flex-col justify-between h-[90vh]">
      <div id="message-box" className="flex-grow overflow-y-auto">
        {
          
          messages.map((message:MessageType, index:number)=>{
            if(message.role === "user" && typeof(message.content)==="string"){
              return(
                  <div key={index}>
                    {clientMessage(message.content)}
                  </div>
              )
            }

            else if(message.role === "assistant"){
              if(message.content_type === "table" && typeof(message.content)!="string"){
                if(message.content.length == 0 || message.content == null){
                  return (
                      <></>
                  )
                }
                return (
                  <div key={index}>
                    { assistantTableMessage(message.content) }
                  </div>
                )
              }

              else if(message.content_type == "query" && typeof(message.content) == "string"){
                return (
                  <div key={index}>
                    { assistantQueryMessage(message.content) }
                  </div>
                )
              }

              else if(message.content_type == "text" && typeof(message.content) == "string"){
                return (
                  <div key={index}>
                    { assistantTextMessage(message.content) }
                  </div>
                )
              }

              else if(message.content_type === "image" && typeof(message.content) == "string"){
                return (
                  <div key={index}>
                    { assistantImageMessage(message.content) }
                  </div>
                )
              }
            }
          })

        }
      </div>

      <div className="flex">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="w-full p-2 border border-gray-300 rounded-lg"
        />
        <Button
          onClick={sendQuery}
          className="ml-2 p-2 bg-blue-500 text-white rounded-lg"
          disabled={isButtonDisabled}
        >
          Send
        </Button>
        <Button
          onClick={getInsights}
          disabled={isInsightsButtonDisabled}
        >
          Get Insights
        </Button>
      </div>
    </div>
  );
}
