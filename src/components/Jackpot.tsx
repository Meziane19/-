import React from 'react';

interface JackpotProps {
  value: number;
}

const Jackpot: React.FC<JackpotProps> = ({ value }) => {
  return (
    <div className="bg-gradient-to-r from-yellow-400 to-yellow-600 p-4 rounded-lg shadow-lg">
      <h2 className="text-2xl font-bold text-white text-center">Jackpot</h2>
      <div className="text-4xl font-bold text-white text-center mt-2">
        ${value}
      </div>
    </div>
  );
};

export default Jackpot;