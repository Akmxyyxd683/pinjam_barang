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
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { ItemsService } from './items.service';
import { ItemDto } from './dto/items.dto';
import { FileInterceptor } from '@nestjs/platform-express/multer/interceptors';

@Controller('items')
export class ItemsController {
  constructor(private readonly itemsService: ItemsService) {}

  @Post('add')
  async create(@Body() dto: ItemDto) {
    try {
      console.log('🔄 Starting item creation with DTO:', dto);
      return await this.itemsService.create(dto);
    } catch (error) {
      // Debug logging - untuk melihat struktur error yang sebenarnya
      console.error('❌ Controller Error Details:');
      console.error('Error type:', typeof error);
      console.error('Error constructor:', error?.constructor?.name);
      console.error('Error keys:', error ? Object.keys(error) : 'No keys');
      console.error('Full error object:', JSON.stringify(error, null, 2));
      console.error('Error message:', error?.message);
      console.error('Error stack:', error?.stack);

      throw new HttpException(
        `Gagal menambahkan item: ${error?.message || error || 'Unknown error'}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get()
  async findAll() {
    try {
      const item = await this.itemsService.findAll();
      return {
        success: true,
        data: item,
      };
    } catch (error) {
      throw new HttpException(
        `Gagal mengambil data: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const item = await this.itemsService.findOne(+id);
    if (!item) {
      throw new HttpException('Item tidak ditemukan', HttpStatus.NOT_FOUND);
    }
    return item;
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() dto: ItemDto) {
    try {
      const updated = await this.itemsService.updateStatus(+id, dto);
      if (!updated) {
        throw new HttpException(
          'Gagal update, item tidak ditemukan',
          HttpStatus.NOT_FOUND,
        );
      }
      return updated;
    } catch (error) {
      throw new HttpException(
        `Gagal update status item: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    try {
      const deleted = await this.itemsService.remove(+id);
      if (!deleted) {
        throw new HttpException('Item tidak ditemukan', HttpStatus.NOT_FOUND);
      }
      return deleted;
    } catch (error) {
      throw new HttpException(
        `Gagal menghapus item: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
