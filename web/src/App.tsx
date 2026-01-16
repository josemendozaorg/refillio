import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { BrowserRouter, Routes, Route, Outlet } from 'react-router-dom';
import DashboardScreen from './features/dashboard/DashboardScreen';
import PantryScreen from './features/inventory/PantryScreen';
import AddItemScreen from './features/inventory/AddItemScreen';
import { Toaster } from 'sonner'; // Will use sonner for toasts or similar

const queryClient = new QueryClient();

function Layout() {
  return (
    <div className="min-h-screen bg-[#0D1117] text-white font-sans relative overflow-x-hidden">
      {/* Global Background Glow */}
      <div className="fixed top-[-150px] left-[-150px] w-[400px] h-[400px] rounded-full bg-primary/15 blur-3xl pointer-events-none z-0" />

      <div className="relative z-10 max-w-md mx-auto min-h-screen bg-[#0D1117] shadow-2xl overflow-hidden">
         {/* Constrain width to mimic mobile app on desktop, or can be full width.
             Given "identical" usually implies visual identity, constraining to mobile width on desktop
             is a common strategy for "mobile-first" web ports, but usually a web app should use available space.
             However, the Flutter app is "Mobile". I will assume a mobile-first responsive design,
             centering content on desktop if needed, or just full width.
             Let's go with full width but max-w-md for the "app" feel if the user opens it on desktop,
             or maybe just responsive.
             The Flutter code has Scaffold, SafeArea.
             I'll use a max-w-md centered container for the "mobile view" experience since it's a mobile app port.
             But actually, a "web implementation" usually expects a responsive web app.
             But `DashboardScreen` has specific pixel values and layout.
             I will stick to a responsive layout but optimized for mobile view since the design is clearly mobile.
          */}
        <Outlet />
      </div>
      <Toaster theme="dark" position="bottom-center" />
    </div>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<DashboardScreen />} />
            <Route path="/inventory" element={<PantryScreen />} />
            <Route path="/inventory/add" element={<AddItemScreen />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  );
}

export default App;
