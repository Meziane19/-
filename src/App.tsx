import React, { useState } from 'react';
import Wheel from './components/Wheel';
import Jackpot from './components/Jackpot';
import Confetti from 'react-confetti';

function App() {
  const [balance, setBalance] = useState(100);
  const [jackpot, setJackpot] = useState(1000);
  const [showConfetti, setShowConfetti] = useState(false);

  const handleSpinComplete = (prize: number) => {
    if (prize === 5) {
      setShowConfetti(true);
      setTimeout(() => setShowConfetti(false), 5000);
    }
    setBalance(prev => prev + prize);
    setJackpot(prev => prize === 5 ? 1000 : prev + 10);
  };

  return (
    <div className="min-h-screen bg-gray-900 text-white p-8">
      {showConfetti && <Confetti />}
      <div className="max-w-2xl mx-auto">
        <h1 className="text-4xl font-bold text-center mb-8">Virtual Wheel Game</h1>
        
        <div className="mb-8">
          <Jackpot value={jackpot} />
        </div>

        <div className="bg-gray-800 p-8 rounded-lg shadow-xl">
          <div className="text-2xl text-center mb-8">
            Your Balance: <span className="font-bold text-green-400">${balance}</span>
          </div>

          <Wheel onSpinComplete={handleSpinComplete} />
          
          <div className="mt-8 text-center text-gray-400">
            <p>Spin the wheel to win virtual coins!</p>
            <p>Land on 5$ to win big!</p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;