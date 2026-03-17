import type { ButtonHTMLAttributes } from 'react';
import { cn } from '../lib/utils';

const variants = {
  primary: 'bg-slate-900 text-white hover:bg-slate-700',
  secondary: 'bg-white text-slate-900 border border-slate-300 hover:bg-slate-50',
} as const;

type Variant = keyof typeof variants;

export function Button({
  className,
  variant = 'primary',
  ...props
}: ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant }) {
  return (
    <button
      className={cn('rounded-md px-4 py-2 text-sm font-medium transition-colors', variants[variant], className)}
      {...props}
    />
  );
}
