export class BorrowingTransactionDto {
  id: number;
  user_id: number;
  item_id: number;
  borrowed_at: Date;
  due_date: Date;
  returned_at: Date;
  description?: string;
  location?: string;
}
