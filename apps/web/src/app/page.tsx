import Link from 'next/link';

const routes = ['login', 'dashboard', 'onboarding', 'settings', 'reports', 'chat'];

export default function LandingPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-5xl flex-col gap-8 p-8">
      <h1 className="text-4xl font-bold">Growth Signal</h1>
      <p className="text-slate-600">Turn user behavior into repeatable growth loops.</p>
      <div className="grid gap-3 sm:grid-cols-2">
        {routes.map((route) => (
          <Link
            key={route}
            href={`/${route}`}
            className="rounded-lg border border-slate-200 bg-white p-4 capitalize shadow-sm hover:bg-slate-50"
          >
            {route}
          </Link>
        ))}
      </div>
    </main>
  );
}
