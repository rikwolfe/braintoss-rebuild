import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Braintoss Rebuild',
  description: 'A complete rebuild of the Braintoss application with modern architecture and improved user experience.',
  keywords: ['braintoss', 'productivity', 'note-taking', 'capture'],
  authors: [{ name: 'Richard Wolfe' }],
  creator: 'Richard Wolfe',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className="h-full">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </head>
      <body className={`${inter.className} h-full bg-gray-50 text-gray-900`}>
        <div className="min-h-screen flex flex-col">
          <main className="flex-1">
            {children}
          </main>
        </div>
      </body>
    </html>
  )
}