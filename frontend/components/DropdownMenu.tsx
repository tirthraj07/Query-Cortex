"use client"
import React, { SetStateAction, useState } from 'react';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

export default function DropdownMenu({
    llmModel,
    setLLMModel
}:{ 
    llmModel:string,
    setLLMModel:React.Dispatch<SetStateAction<string>>

}) {

  return (
    <div className="flex items-center">
      <Select value={llmModel} onValueChange={(value)=>setLLMModel(value)} >
          <SelectTrigger id="llmModel" className="p-3 gap-3">
          <SelectValue placeholder="Select" />
          </SelectTrigger>
          <SelectContent position="popper">
          <SelectItem value="gemini">Gemini</SelectItem>
          <SelectItem value="worqhat">Worqhat</SelectItem>
          </SelectContent>
      </Select>

    </div>
  );
}
