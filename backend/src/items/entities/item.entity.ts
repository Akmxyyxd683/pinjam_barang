import { BorrowingTransaction } from 'src/borrowing_transactions/entities/borrowing_transaction.entity';
import { Category } from 'src/categories/entities/category.entity';
import {
  Entity,
  Column,
  PrimaryColumn,
  OneToOne,
  OneToMany,
  ManyToOne,
  JoinColumn,
} from 'typeorm';

export enum ItemStatus {
  AVAILABLE = 'available',
  BORROWED = 'borrowed',
  NOT_AVAILABLE = 'Not available',
}

@Entity('items')
export class Item {
  @PrimaryColumn()
  id: number;

  @Column()
  category_id: number;

  @Column()
  name: string;

  @Column({ nullable: true })
  img_url: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  create_at: Date;

  @Column()
  status: ItemStatus;

  @ManyToOne(() => Category, (category) => category.items)
  @JoinColumn({ name: 'category_id' })
  category: Category;
  borrowingTransactions: any;

  @OneToMany(
    () => BorrowingTransaction,
    (borrowingTransaction) => borrowingTransaction.item,
  )
  transactions: BorrowingTransaction[];
}
