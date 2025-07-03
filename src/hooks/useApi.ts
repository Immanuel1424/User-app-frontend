
import { useState, useEffect } from 'react';
import { apiService } from '@/services/api';
import { useToast } from '@/hooks/use-toast';

interface UseApiOptions {
  autoFetch?: boolean;
  onSuccess?: (data: any) => void;
  onError?: (error: Error) => void;
}

export function useApi<T>(
  endpoint: string,
  options: UseApiOptions = {}
) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  const { toast } = useToast();

  const { autoFetch = true, onSuccess, onError } = options;

  const fetchData = async () => {
    setLoading(true);
    setError(null);

    try {
      const response = await apiService.get<T>(endpoint);
      setData(response.data);
      onSuccess?.(response.data);
    } catch (err) {
      const error = err instanceof Error ? err : new Error('Unknown error');
      setError(error);
      onError?.(error);
      toast({
        title: 'Error',
        description: error.message,
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  const mutate = async (method: 'POST' | 'PUT' | 'DELETE', body?: any) => {
    setLoading(true);
    setError(null);

    try {
      let response;
      switch (method) {
        case 'POST':
          response = await apiService.post<T>(endpoint, body);
          break;
        case 'PUT':
          response = await apiService.put<T>(endpoint, body);
          break;
        case 'DELETE':
          response = await apiService.delete<T>(endpoint);
          break;
      }
      
      setData(response.data);
      onSuccess?.(response.data);
      toast({
        title: 'Success',
        description: 'Operation completed successfully',
      });
      
      return response;
    } catch (err) {
      const error = err instanceof Error ? err : new Error('Unknown error');
      setError(error);
      onError?.(error);
      toast({
        title: 'Error',
        description: error.message,
        variant: 'destructive',
      });
      throw error;
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (autoFetch) {
      fetchData();
    }
  }, [endpoint, autoFetch]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
    mutate,
  };
}
