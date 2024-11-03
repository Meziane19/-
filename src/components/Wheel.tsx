import React, { useState, useEffect } from 'react';

interface WheelProps {
  onSpinComplete: (prize: number) => void;
}

const Wheel: React.FC<WheelProps> = ({ onSpinComplete }) => {
  const [rotation, setRotation] = useState(0);
  const [isSpinning, setIsSpinning] = useState(false);

  const segments = [0, 1, 0, 1, 5, 0, 1, 0, 1, 0];
  const segmentAngle = 360 / segments.length;

  const spinWheel = () => {
    if (isSpinning) return;

    setIsSpinning(true);
    const spins = 5; // Number of full rotations
    const randomSegment = Math.floor(Math.random() * segments.length);
    const finalAngle = spins * 360 + (randomSegment * segmentAngle);
    
    setRotation(finalAngle);

    setTimeout(() => {
      setIsSpinning(false);
      onSpinComplete(segments[randomSegment]);
    }, 5000);
  };

  return (
    <div className="relative w-64 h-64 mx-auto">
      <div 
        className="absolute w-full h-full rounded-full border-4 border-gray-800"
        style={{
          transform: `rotate(${rotation}deg)`,
          transition: 'transform 5s cubic-bezier(0.17, 0.67, 0.12, 0.99)',
          backgroundImage: `conic-gradient(
            from 0deg,
            #FF6B6B 0deg ${segmentAngle}deg,
            #4ECDC4 ${segmentAngle}deg ${2 * segmentAngle}deg,
            #FFD93D ${2 * segmentAngle}deg ${3 * segmentAngle}deg,
            #6C5B7B ${3 * segmentAngle}deg ${4 * segmentAngle}deg,
            #45B7D1 ${4 * segmentAngle}deg ${5 * segmentAngle}deg,
            #FF6B6B ${5 * segmentAngle}deg ${6 * segmentAngle}deg,
            #4ECDC4 ${6 * segmentAngle}deg ${7 * segmentAngle}deg,
            #FFD93D ${7 * segmentAngle}deg ${8 * segmentAngle}deg,
            #6C5B7B ${8 * segmentAngle}deg ${9 * segmentAngle}deg,
            #45B7D1 ${9 * segmentAngle}deg 360deg
          )`
        }}
      >
        {segments.map((value, index) => (
          <div
            key={index}
            className="absolute w-full h-full flex items-center justify-center text-white font-bold"
            style={{
              transform: `rotate(${index * segmentAngle + segmentAngle/2}deg)`,
            }}
          >
            {value}$
          </div>
        ))}
      </div>
      <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
        <button
          onClick={spinWheel}
          disabled={isSpinning}
          className="bg-red-600 text-white px-4 py-2 rounded-full hover:bg-red-700 disabled:bg-gray-400"
        >
          {isSpinning ? 'Spinning...' : 'SPIN!'}
        </button>
      </div>
    </div>
  );
};

export default Wheel;