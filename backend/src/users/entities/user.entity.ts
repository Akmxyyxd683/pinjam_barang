import { BorrowingTransaction } from 'src/borrowing_transactions/entities/borrowing_transaction.entity';
import { text } from 'stream/consumers';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  name: string;

  @Column({ type: 'text', nullable: true })
  profile_img: string | null;

  @Column()
  role: string;

  @Column()
  no_telp: string;

  @Column()
  alamat: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @OneToMany(
    () => BorrowingTransaction,
    (borrowingTransaction) => borrowingTransaction.user,
  )
  borrowingTransactions: BorrowingTransaction[];
}
