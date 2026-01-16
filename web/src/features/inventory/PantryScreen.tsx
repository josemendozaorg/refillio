import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { ArrowLeft, Plus, AlertTriangle, Package2, MinusCircle, Trash2, Loader2, Check } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { toast } from 'sonner';
import { getPantry, logConsumption } from '../../lib/api';
import { demoUserId, filterPantryItems } from '../../lib/constants';
import { cn } from '../../lib/utils';
import type { InventoryItem } from '../../types';

export default function PantryScreen() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [selectedFilter, setSelectedFilter] = useState('All');

  const { data: pantryItems, isLoading, error } = useQuery({
    queryKey: ['pantry', demoUserId],
    queryFn: () => getPantry(demoUserId),
  });

  const consumeMutation = useMutation({
    mutationFn: ({ item, amount, type }: { item: InventoryItem; amount: number; type: string }) =>
      logConsumption(item.id, amount, type),
    onSuccess: (_, { amount }) => {
      queryClient.invalidateQueries({ queryKey: ['pantry', demoUserId] });
      toast.success(amount === 0 ? 'Item marked as exhausted.' : 'Consumed 1 unit.');
    },
    onError: (err) => {
      toast.error(`Error: ${err}`);
    }
  });

  const handleConsume = (item: InventoryItem) => {
    consumeMutation.mutate({ item, amount: 1.0, type: 'manual_reduction' });
  };

  const handleExhaust = (item: InventoryItem) => {
    consumeMutation.mutate({ item, amount: 0, type: 'exhausted' });
  };

  const filteredItems = pantryItems ? filterPantryItems(pantryItems, selectedFilter) : [];

  return (
    <div className="min-h-screen pb-24">
      {/* App Bar */}
      <div className="sticky top-0 z-20 bg-[#0D1117]/80 backdrop-blur-md p-4 flex items-center gap-4">
        <button onClick={() => navigate(-1)} className="p-2 -ml-2 rounded-full hover:bg-white/5">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="text-xl font-semibold">My Pantry</h1>
      </div>

      <div className="px-5 space-y-4">
        {/* Filters */}
        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {['All', 'Low Stock', 'Produce', 'Dairy', 'Pantry'].map((filter) => {
            const isSelected = selectedFilter === filter;
            return (
              <button
                key={filter}
                onClick={() => setSelectedFilter(filter)}
                className={cn(
                  "px-3 py-1.5 rounded-xl text-[13px] whitespace-nowrap border transition-all duration-200 flex items-center gap-1.5",
                  isSelected
                    ? "bg-primary/20 border-primary text-primary font-bold"
                    : "bg-white/5 border-white/10 text-white/60 font-normal hover:bg-white/10"
                )}
              >
                {isSelected && <Check className="w-3 h-3" />}
                {filter}
              </button>
            );
          })}
        </div>

        {/* Content */}
        {isLoading ? (
          <div className="flex justify-center py-20"><Loader2 className="animate-spin text-white/50" /></div>
        ) : error ? (
          <div className="text-center text-red-400 py-10">Error loading pantry items</div>
        ) : filteredItems.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 text-white/60">
            <Package2 className="w-20 h-20 text-white/10 mb-5" />
            <p className="text-xl font-medium text-white/60">Your pantry is empty</p>
          </div>
        ) : (
          <div className="space-y-4">
            <AnimatePresence mode='popLayout'>
              {filteredItems.map((item, index) => (
                <PantryItemCard
                  key={item.id}
                  item={item}
                  index={index}
                  onConsume={() => handleConsume(item)}
                  onExhaust={() => handleExhaust(item)}
                />
              ))}
            </AnimatePresence>
          </div>
        )}
      </div>

      {/* FAB */}
      <motion.button
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{ delay: 0.5, type: 'spring' }}
        onClick={() => navigate('/inventory/add')}
        className="fixed bottom-6 right-6 bg-primary text-white px-5 py-3.5 rounded-2xl shadow-lg flex items-center gap-2 font-semibold hover:bg-primary/90 transition-colors z-30"
      >
        <Plus className="w-6 h-6" />
        Add Item
      </motion.button>
    </div>
  );
}

function PantryItemCard({
  item,
  index,
  onConsume,
  onExhaust
}: {
  item: InventoryItem,
  index: number,
  onConsume: () => void,
  onExhaust: () => void
}) {
  const isLow = item.currentQty <= item.reorderPoint;
  const progress = Math.min((item.currentQty / (item.reorderPoint * 2)), 1) * 100;

  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      transition={{ delay: index * 0.05, ease: "easeOut" }}
      className="bg-white/[0.04] border border-white/[0.05] rounded-[20px] p-4"
    >
      <div className="flex items-start gap-4">
        {/* Icon */}
        <div className={cn(
          "w-12 h-12 rounded-xl flex items-center justify-center shrink-0",
          isLow ? "bg-amber-500/10 text-amber-500" : "bg-emerald-500/10 text-emerald-500"
        )}>
          {isLow ? <AlertTriangle className="w-6 h-6" /> : <Package2 className="w-6 h-6" />}
        </div>

        {/* Info */}
        <div className="flex-1 min-w-0">
          <h3 className="text-lg font-bold truncate text-white">{item.product?.name ?? 'Unknown'}</h3>
          <p className="text-[13px] text-white/60">
            {item.currentQty} {item.product?.unitSymbol ?? ''} left
          </p>
        </div>

        {/* Actions */}
        <div className="flex items-center gap-1">
          <button onClick={onConsume} className="p-2 text-white/60 hover:text-white hover:bg-white/10 rounded-full transition-colors">
            <MinusCircle className="w-6 h-6" />
          </button>
          <button onClick={onExhaust} className="p-2 text-red-400/60 hover:text-red-400 hover:bg-red-400/10 rounded-full transition-colors">
            <Trash2 className="w-6 h-6" />
          </button>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="mt-4 h-1 w-full bg-white/5 rounded-full overflow-hidden">
        <div
          className={cn("h-full transition-all duration-500", isLow ? "bg-amber-500" : "bg-emerald-500")}
          style={{ width: `${progress}%` }}
        />
      </div>
    </motion.div>
  );
}
