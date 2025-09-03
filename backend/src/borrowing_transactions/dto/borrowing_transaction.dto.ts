import { BorrowStatus } from '../entities/borrowing_transaction.entity';

export class BorrowingTransactionDto {
  id: number;
  user_id: number;
  item_id: number;
  status?: BorrowStatus;
  requested_at: Date;
  approved_at: Date;
  borrowed_at: Date;
  due_date: Date;
  returned_at: Date;
  description?: string;
  location?: string;
}
