import React from 'react';
import { cn } from '../../lib/utils';
import { motion, type HTMLMotionProps } from 'framer-motion';

interface GlassContainerProps extends HTMLMotionProps<"div"> {
  children: React.ReactNode;
  className?: string;
  padding?: string;
}

export const GlassContainer = ({ children, className, padding = "p-6", ...props }: GlassContainerProps) => {
  return (
    <motion.div
      className={cn(
        "backdrop-blur-md bg-white/5 border border-white/10 rounded-3xl overflow-hidden",
        padding,
        className
      )}
      {...props}
    >
      {children}
    </motion.div>
  );
};
