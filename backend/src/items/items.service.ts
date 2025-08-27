import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository } from 'typeorm';
import { Item } from './entities/item.entity';
import { ItemDto, ItemStatus } from './dto/items.dto';
import { v2 as cloudinary } from 'cloudinary';
import { UploadApiResponse } from 'cloudinary';
import * as streamifier from 'streamifier';

@Injectable()
export class ItemsService {
  constructor(
    @InjectRepository(Item)
    private readonly itemRepository: Repository<Item>,
  ) {}

  async create(dto: ItemDto): Promise<Item> {
    let imageUrl: string | null = null;

    if (dto.img_url) {
      let imageToUpload = dto.img_url;

      // Kalau base64 tidak ada prefix "data:image", tambahin biar Cloudinary bisa baca
      if (!dto.img_url.startsWith('data:image')) {
        imageToUpload = `data:image/png;base64,${dto.img_url}`;
      }

      const result = await cloudinary.uploader.upload(imageToUpload, {
        folder: 'nestjs_items',
      });

      imageUrl = result.secure_url;
    }

    const item = this.itemRepository.create({
      ...dto,
      img_url: imageUrl,
    } as DeepPartial<Item>);

    return this.itemRepository.save(item);
  }

  async findAll(): Promise<Item[]> {
    return this.itemRepository.find();
  }

  async findOne(id: number): Promise<Item> {
    const item = await this.itemRepository.findOne({ where: { id } });
    if (!item) throw new NotFoundException('Item not found');
    return item;
  }

  async updateStatus(id: number, dto: ItemDto): Promise<Item> {
    const item = await this.findOne(id);
    item.status = dto.status;
    return this.itemRepository.save(item);
  }

  async remove(id: number): Promise<boolean> {
    const item = await this.itemRepository.findOne({ where: { id } });
    if (!item) return false;

    await this.itemRepository.remove(item);
    return true;
  }

  async findAvailable(): Promise<ItemDto[]> {
    const items = await this.itemRepository.find({
      where: { status: ItemStatus.AVAILABLE },
    });

    return items.map((item) => ({
      id: item.id,
      category_id: item.category_id,
      name: item.name,
      img_url: item.img_url,
      create_at: item.create_at,
      status: item.status,
    }));
  }
}
