import { useNavigate } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { User, ChevronRight, AlertTriangle, Leaf, QrCode, Plus, List, Loader2 } from 'lucide-react';
import { getPantry } from '../../lib/api';
import { demoUserId, getLowStockItems } from '../../lib/constants';
import { GlassContainer } from '../../components/ui/GlassContainer';
import { cn } from '../../lib/utils';
import type { InventoryItem } from '../../types';

export default function DashboardScreen() {
  const navigate = useNavigate();
  const { data: pantryItems, isLoading, error } = useQuery({
    queryKey: ['pantry', demoUserId],
    queryFn: () => getPantry(demoUserId),
  });

  const lowStockItems = pantryItems ? getLowStockItems(pantryItems) : [];

  return (
    <div className="p-5 pb-20 space-y-8">
      {/* Header */}
      <div className="flex justify-between items-start pt-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Refillio</h1>
          <p className="text-white/50 text-sm">Your smart pantry manager</p>
        </div>
        <GlassContainer padding="p-2.5" className="rounded-xl cursor-pointer" onClick={() => {}}>
          <User className="w-6 h-6 text-white" />
        </GlassContainer>
      </div>

      {/* Summary Card */}
      <GlassContainer padding="p-6">
        <div className="flex justify-between mb-6">
          <StatItem
            label="Items"
            value={isLoading ? "..." : pantryItems?.length.toString() ?? "!"}
          />
          <StatItem label="Categories" value="12" />
          <StatItem label="Value" value="$450" isCurrency />
        </div>

        {/* Pantry Status */}
        <div className="space-y-2.5">
          <div className="flex justify-between">
            <span className="text-sm font-semibold text-white/80">85% Stocked</span>
          </div>
          <div className="h-2 w-full bg-white/10 rounded-full overflow-hidden">
            <div className="h-full bg-primary w-[85%]" />
          </div>
        </div>
      </GlassContainer>

      {/* Low Stock Alerts */}
      <div>
        <SectionHeader title="Low Stock Alerts" />
        <div className="mt-4 h-[160px]">
          {isLoading ? (
            <div className="h-full flex items-center justify-center"><Loader2 className="animate-spin text-white/50" /></div>
          ) : error ? (
            <div className="h-full flex items-center justify-center text-red-400">Error loading data</div>
          ) : lowStockItems.length === 0 ? (
            <GlassContainer className="h-full flex items-center justify-center">
              <span className="text-white/70">All items are well-stocked!</span>
            </GlassContainer>
          ) : (
            <div className="flex gap-4 overflow-x-auto pb-2 snap-x">
              {lowStockItems.map((item) => (
                <AlertCard key={item.id} item={item} />
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Quick Actions */}
      <div>
        <SectionHeader title="Quick Actions" />
        <div className="flex justify-between mt-5 px-2">
          <QuickAction icon={QrCode} label="Scan Item" onTap={() => {}} />
          <QuickAction icon={Plus} label="Add Item" onTap={() => navigate('/inventory/add')} />
          <QuickAction icon={List} label="Shopping List" onTap={() => {}} />
        </div>
      </div>

      <div className="text-center pt-10">
        <p className="text-xs text-white/50 tracking-widest">Refillio v1.0.0</p>
      </div>
    </div>
  );
}

function SectionHeader({ title }: { title: string }) {
  return (
    <div className="flex justify-between items-center">
      <h2 className="text-lg font-semibold">{title}</h2>
      <ChevronRight className="w-5 h-5 text-white/50" />
    </div>
  );
}

function StatItem({ label, value, isCurrency }: { label: string, value: string, isCurrency?: boolean }) {
  return (
    <div className="flex flex-col">
      <span className={cn("text-2xl font-bold", isCurrency ? "text-white" : "text-white/90")}>
        {value}
      </span>
      <span className="text-xs font-medium text-white/50">{label}</span>
    </div>
  );
}

function AlertCard({ item }: { item: InventoryItem }) {
  const isCritical = item.currentQty <= item.reorderPoint * 0.5;
  const status = isCritical ? 'Critical, Gold' : 'Low, Emerald';
  const colorClass = isCritical ? 'bg-amber-500/20 border-amber-500/10' : 'bg-emerald-500/20 border-emerald-500/10';
  const Icon = isCritical ? AlertTriangle : Leaf;

  return (
    <div className={cn(
      "min-w-[160px] w-[160px] rounded-[20px] p-4 flex flex-col border",
      colorClass
    )}>
      <Icon className="w-7 h-7 text-white/80" />
      <div className="flex-1" />
      <p className="font-bold text-base truncate">{item.product?.name ?? 'Unknown'}</p>
      <p className="text-[11px] text-white/60 mt-1">{status}</p>
      <button className="mt-3 w-full bg-white/15 hover:bg-white/20 text-white text-xs font-bold py-2 rounded-lg transition-colors">
        Reorder
      </button>
    </div>
  );
}

function QuickAction({ icon: Icon, label, onTap }: { icon: React.ElementType, label: string, onTap: () => void }) {
  return (
    <div className="flex flex-col items-center gap-3">
      <GlassContainer
        className="w-[72px] h-[72px] rounded-full flex items-center justify-center cursor-pointer hover:bg-white/10 transition-colors"
        padding="p-0"
        onClick={onTap}
      >
        <Icon className="w-[30px] h-[30px] text-white" />
      </GlassContainer>
      <span className="text-xs font-semibold text-white/70">{label}</span>
    </div>
  );
}
