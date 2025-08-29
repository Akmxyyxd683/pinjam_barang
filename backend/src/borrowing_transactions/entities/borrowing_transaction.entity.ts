import { Item } from 'src/items/entities/item.entity';
import { User } from 'src/users/entities/user.entity';
import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';

export enum BorrowStatus {
  REQUESTED = 'REQUESTED',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED',
  RETURNED = 'RETURNED',
  CANCELLED = 'CANCELLED',
}

@Entity()
export class BorrowingTransaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  user_id: number;

  @Column()
  item_id: number;

  @Column()
  borrowed_at: Date;

  @Column()
  due_date: Date;

  @Column()
  returned_at: Date;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  location: string;

  @ManyToOne(() => User, (user) => user.borrowingTransactions)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Item, (item) => item.transactions)
  @JoinColumn({ name: 'item_id' })
  item: Item;
}
