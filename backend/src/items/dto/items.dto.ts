export enum ItemStatus {
  AVAILABLE = 'available',
  BORROWED = 'borrowed',
  NOT_AVAILABLE = 'Not available',
}

export class ItemDto {
  id?: number;
  category_id: number;
  img_url: string;
  name: string;
  create_at: Date;
  status: ItemStatus;
}
