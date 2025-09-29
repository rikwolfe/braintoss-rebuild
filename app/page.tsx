'use client';

import React, { useState, useRef, useEffect } from 'react';
import { 
  MicrophoneIcon, 
  CameraIcon, 
  PaperAirplaneIcon,
  ArchiveBoxIcon,
  Cog6ToothIcon,
  DocumentIcon,
  XMarkIcon,
  PlusIcon
} from '@heroicons/react/24/outline';

// This will be moved to a proper state management solution later
interface StagedAttachment {
  type: 'image' | 'pdf';
  filename: string;
  preview?: string; // for images
}

export default function MainTextScreen() {
  const [textInput, setTextInput] = useState('');
  const [stagedAttachments, setStagedAttachments] = useState<StagedAttachment[]>([]);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  // Auto-focus text area on mount (spec requirement)
  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.focus();
    }
  }, []);

  // Handle send action
  const handleSend = (isLongPress: boolean = false) => {
    // TODO: Implement actual send logic based on spec
    console.log('Sending toss:', { 
      text: textInput, 
      attachments: stagedAttachments,
      isLongPress 
    });
    
    // Clear after sending (spec requirement)
    setTextInput('');
    setStagedAttachments([]);
    
    // Re-focus for next input
    setTimeout(() => {
      if (textareaRef.current) {
        textareaRef.current.focus();
      }
    }, 100);
  };

  // Handle voice recording
  const handleVoiceRecord = () => {
    // TODO: Navigate to Voice Recording Screen
    console.log('Starting voice recording...');
  };

  // Handle photo capture
  const handlePhotoCapture = () => {
    // TODO: Navigate to Camera Screen
    console.log('Opening camera...');
  };

  // Remove staged attachment
  const removeAttachment = (index: number) => {
    setStagedAttachments(prev => prev.filter((_, i) => i !== index));
  };

  return (
    <div className="braintoss-screen">
      {/* Gradient Background */}
      <div className="braintoss-bg">
        {/* Top Header Pill */}
        <div className="header-pill">
          <button className="header-btn">
            <ArchiveBoxIcon className="w-6 h-6 text-yellow-400" />
          </button>
          <button className="header-btn">
            <Cog6ToothIcon className="w-6 h-6 text-yellow-400" />
          </button>
        </div>

        {/* Main Content Area */}
        <div className="main-content">
          {/* Text Input Card */}
          <div className="text-card">
            <textarea
              ref={textareaRef}
              value={textInput}
              onChange={(e) => setTextInput(e.target.value)}
              placeholder="Type your thoughts…"
              className="braintoss-textarea"
              rows={12}
            />
            
            {/* Attachment Strip */}
            {stagedAttachments.length > 0 && (
              <div className="attachment-strip">
                {stagedAttachments.map((attachment, index) => (
                  <div key={index} className="relative">
                    {attachment.type === 'image' ? (
                      <div className="relative">
                        <img
                          src={attachment.preview}
                          alt={attachment.filename}
                          className="attachment-thumbnail"
                        />
                        <button
                          onClick={() => removeAttachment(index)}
                          className="absolute -top-2 -right-2 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center hover:bg-red-600"
                        >
                          <XMarkIcon className="w-4 h-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="attachment-chip">
                        <DocumentIcon className="w-4 h-4 mr-2" />
                        <span className="truncate max-w-32">{attachment.filename}</span>
                        <button
                          onClick={() => removeAttachment(index)}
                          className="ml-2 w-4 h-4 text-gray-500 hover:text-red-500"
                        >
                          <XMarkIcon className="w-4 h-4" />
                        </button>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Floating Action Buttons */}
          <div className="floating-actions">
            {/* Voice Button (left) */}
            <button 
              onClick={handleVoiceRecord}
              className="floating-btn floating-btn-voice"
              title="Record voice note"
            >
              <div className="floating-btn-bg floating-btn-bg-yellow">
                <MicrophoneIcon className="w-7 h-7 text-blue-700" />
                <div className="floating-btn-plus">
                  <PlusIcon className="w-4 h-4 text-white" />
                </div>
              </div>
            </button>

            {/* Send Button (center, large) */}
            <button 
              onClick={() => handleSend(false)}
              onContextMenu={(e) => {
                e.preventDefault();
                handleSend(true);
              }}
              className="floating-btn floating-btn-send"
              disabled={!textInput.trim() && stagedAttachments.length === 0}
            >
              <div className="floating-btn-bg floating-btn-bg-blue">
                <PaperAirplaneIcon className="w-8 h-8 text-yellow-400" />
              </div>
            </button>

            {/* Photo Button (right) */}
            <button 
              onClick={handlePhotoCapture}
              className="floating-btn floating-btn-photo"
              title="Take or choose photo"
            >
              <div className="floating-btn-bg floating-btn-bg-yellow">
                <CameraIcon className="w-7 h-7 text-blue-700" />
                <div className="floating-btn-plus">
                  <PlusIcon className="w-4 h-4 text-white" />
                </div>
              </div>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}