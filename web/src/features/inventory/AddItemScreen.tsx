import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { ArrowLeft, Search, ShoppingBag, PlusCircle, X, Loader2 } from 'lucide-react';
import { motion } from 'framer-motion';
import { toast } from 'sonner';
import { getProducts, addToPantry } from '../../lib/api';
import { demoUserId } from '../../lib/constants';
import type { CanonicalProduct } from '../../types';

export default function AddItemScreen() {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedProduct, setSelectedProduct] = useState<CanonicalProduct | null>(null);

  const { data: products, isLoading, error } = useQuery({
    queryKey: ['products'],
    queryFn: getProducts,
  });

  const filteredProducts = products
    ? products.filter(p => p.name.toLowerCase().includes(searchQuery.toLowerCase()))
    : [];

  return (
    <div className="min-h-screen pb-6">
      {/* App Bar */}
      <div className="sticky top-0 z-20 bg-[#0D1117]/90 backdrop-blur-md p-4 flex items-center gap-4">
        <button onClick={() => navigate(-1)} className="p-2 -ml-2 rounded-full hover:bg-white/5">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="text-xl font-semibold">Catalog</h1>
      </div>

      <div className="px-5">
        {/* Search Bar */}
        <div className="relative mb-4">
          <div className="absolute left-3 top-1/2 -translate-y-1/2 text-white/40">
            <Search className="w-5 h-5" />
          </div>
          <input
            type="text"
            placeholder="Search products..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-10 pr-10 text-white placeholder:text-white/40 focus:outline-none focus:border-primary/50 transition-colors"
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery('')}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-white/40 hover:text-white"
            >
              <X className="w-4 h-4" />
            </button>
          )}
        </div>

        {/* List */}
        {isLoading ? (
          <div className="flex justify-center py-20"><Loader2 className="animate-spin text-white/50" /></div>
        ) : error ? (
          <div className="text-center text-red-400 py-10">Error loading catalog</div>
        ) : filteredProducts.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 text-white/60">
            <Search className="w-16 h-16 text-white/10 mb-4" />
            <p className="text-base text-white/40">No products found</p>
          </div>
        ) : (
          <div className="space-y-3">
            {filteredProducts.map((product, index) => (
              <ProductCard
                key={product.id}
                product={product}
                index={index}
                onTap={() => setSelectedProduct(product)}
              />
            ))}
          </div>
        )}
      </div>

      {selectedProduct && (
        <AddItemDialog
          product={selectedProduct}
          onClose={() => setSelectedProduct(null)}
        />
      )}
    </div>
  );
}

function ProductCard({ product, index, onTap }: { product: CanonicalProduct, index: number, onTap: () => void }) {
  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay: index * 0.03, ease: "easeOut" }}
      onClick={onTap}
      className="bg-white/[0.04] border border-white/[0.05] rounded-2xl p-4 flex items-center gap-4 cursor-pointer hover:bg-white/[0.08] transition-colors"
    >
      <div className="w-11 h-11 rounded-xl bg-white/5 flex items-center justify-center shrink-0">
        <ShoppingBag className="w-5 h-5 text-white/40" />
      </div>

      <div className="flex-1 min-w-0">
        <h3 className="text-base font-bold text-white truncate">{product.name}</h3>
        {product.description && (
          <p className="text-xs text-white/40 truncate">{product.description}</p>
        )}
      </div>

      <PlusCircle className="w-6 h-6 text-primary shrink-0" />
    </motion.div>
  );
}

function AddItemDialog({ product, onClose }: { product: CanonicalProduct, onClose: () => void }) {
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const [qty, setQty] = useState('1');
  const [par, setPar] = useState('1');

  const addMutation = useMutation({
    mutationFn: (request: { productId: string; quantity: number; reorderPoint: number }) => addToPantry(demoUserId, request),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pantry', demoUserId] });
      toast.success(`Added ${product.name} to pantry`);
      onClose();
      navigate('/inventory'); // Or just close dialog? Flutter code says `Navigator.pop` then `context.pop`, which might mean pop dialog then pop screen. Let's just pop dialog and maybe go back to pantry if that's the flow. Actually Flutter code: `Navigator.pop(context); context.pop();` - this means close dialog AND close screen.
      navigate(-1);
    },
    onError: (err) => {
      toast.error(`Error: ${err}`);
    }
  });

  const handleAdd = () => {
    addMutation.mutate({
      productId: product.id,
      quantity: parseFloat(qty) || 1,
      reorderPoint: parseFloat(par) || 1,
    });
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={onClose}
      />
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        className="bg-[#1A1D23] w-full max-w-[320px] rounded-3xl p-6 relative z-10 shadow-2xl border border-white/10"
      >
        <h2 className="text-xl font-bold mb-6">Add {product.name}</h2>

        <div className="space-y-4">
          <DialogInput
            label="Current Quantity"
            value={qty}
            onChange={setQty}
            unit={product.baseUnit?.symbol ?? ''}
          />
          <DialogInput
            label="Reorder Point"
            value={par}
            onChange={setPar}
            unit={product.baseUnit?.symbol ?? ''}
          />
        </div>

        <div className="flex justify-end items-center gap-4 mt-8">
          <button
            onClick={onClose}
            className="text-sm font-medium text-white/40 hover:text-white transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={handleAdd}
            disabled={addMutation.isPending}
            className="bg-primary hover:bg-primary/90 text-white text-sm font-medium px-6 py-3 rounded-xl transition-colors disabled:opacity-50"
          >
            {addMutation.isPending ? 'Adding...' : 'Add to Pantry'}
          </button>
        </div>
      </motion.div>
    </div>
  );
}

function DialogInput({ label, value, onChange, unit }: { label: string, value: string, onChange: (val: string) => void, unit: string }) {
  return (
    <div className="space-y-2">
      <label className="text-xs font-semibold text-white/40 uppercase tracking-wide">{label}</label>
      <div className="relative">
        <input
          type="number"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:outline-none focus:border-primary/50 transition-colors"
        />
        <span className="absolute right-4 top-1/2 -translate-y-1/2 text-white/40 text-sm font-medium">
          {unit}
        </span>
      </div>
    </div>
  );
}
