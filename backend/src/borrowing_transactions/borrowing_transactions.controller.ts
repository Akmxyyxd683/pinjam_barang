import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { BorrowingTransactionsService } from './borrowing_transactions.service';
import { BorrowingTransactionDto } from './dto/borrowing_transaction.dto';

@Controller('borrowing-transactions')
export class BorrowingTransactionsController {
  constructor(
    private readonly borrowingTransactionsService: BorrowingTransactionsService,
  ) {}

  @Post('add')
  async create(@Body() BorrowingTransactionDto: BorrowingTransactionDto) {
    try {
      return await this.borrowingTransactionsService.create(
        BorrowingTransactionDto,
      );
    } catch (error) {
      throw new HttpException(
        `Gagal menambahkan history: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get()
  async findAll() {
    try {
      const transactions = await this.borrowingTransactionsService.findAll();
      return { success: true, data: transactions };
    } catch (error) {
      throw new HttpException(
        `Gagal mendapatkan semua history`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const transaction = await this.borrowingTransactionsService.findOne(+id);
    if (!transaction) {
      throw new HttpException(
        `History yang anda cari tidak ditemukan`,
        HttpStatus.NOT_FOUND,
      );
    } else {
      return transaction;
    }
  }

  @Patch(':id')
  async update(
    @Param('id') id: string,
    @Body() BorrowingTransactionDto: BorrowingTransactionDto,
  ) {
    try {
      const updated = await this.borrowingTransactionsService.update(
        +id,
        BorrowingTransactionDto,
      );
      if (!updated) {
        throw new HttpException(
          'History yang anda cari tidak ditemukan',
          HttpStatus.NOT_FOUND,
        );
      } else {
        return updated;
      }
    } catch (error) {
      throw new HttpException(
        `Gagal mengupdate barang: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    try {
      const deleted = this.borrowingTransactionsService.remove(+id);
      if (!deleted) {
        throw new HttpException(
          `History yang anda cari tidak ditemukan`,
          HttpStatus.NOT_FOUND,
        );
      } else {
        return {
          success: true,
          message: 'data berhasil dihapus',
        };
      }
    } catch (error) {
      throw new HttpException(
        `Gagal menghapus: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
