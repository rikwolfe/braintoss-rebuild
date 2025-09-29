#!/usr/bin/env node

/**
 * Braintoss Rebuild - Main Entry Point
 * 
 * A ground-up rebuild of the Braintoss application focused on modern
 * architecture and improved user experience.
 */

import App from './components/App.js';

console.log('🧠 Braintoss Rebuild - Starting Application...');
console.log('📁 Project Structure Initialized');

export default async function main() {
    try {
        // Create and initialize the main application
        const app = new App();
        
        // Initialize the application
        await app.init();
        
        // Start the application
        app.start();
        
        // Log application info
        const info = app.getInfo();
        console.log('📋 Application Info:', info);
        
        console.log('🔧 Development mode: Ready to build amazing features!');
        
    } catch (error) {
        console.error('❌ Failed to start application:', error.message);
        process.exit(1);
    }
}

// Run if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
    main();
}
