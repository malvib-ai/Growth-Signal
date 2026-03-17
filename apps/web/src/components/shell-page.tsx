import { Button } from '@growth-signal/ui';

export function ShellPage({ title, description }: { title: string; description: string }) {
  return (
    <main className="mx-auto flex min-h-screen max-w-4xl flex-col gap-6 p-8">
      <h1 className="text-3xl font-bold">{title}</h1>
      <p className="text-slate-600">{description}</p>
      <div className="flex gap-3">
        <Button>Primary action</Button>
        <Button variant="secondary">Secondary</Button>
      </div>
    </main>
  );
}
